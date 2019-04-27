//
//  UserController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/18/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import Foundation
import UIKit
//import Firebase Database
import FirebaseAuth
import Firebase

class UserController {
    
    var userFound: Bool = false
    var currentUser: User?
    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    var customer: CheckoutCustomer?
    var serverCurrentUser = Auth.auth().currentUser
    //  var serverCurrentUser = Auth.auth().currentUser
   // private let userRef = Database.database().reference().child("users")
    
    let baseURL = URL(string: "https://type-keto-store.firebaseio.com/")!
    
    func createUserAccount(withEmail email: String, andPassword password: String, andName fullName: String, completion: @escaping (Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                NSLog("Error creating user account: \(error)")
                completion(error)
                return
            }
            
            if let userAccount = user {
                let userLocal = User(emailAddress: userAccount.user.email!, password: password, fullName: fullName, uid: userAccount.user.uid)
                if Auth.auth().currentUser?.uid == userLocal.uid {
            
                    self.currentUser = userLocal
                    self.putUserToServer(user: userLocal, completion: completion)
                    self.changeRequest?.displayName = userLocal.fullName
                    self.changeRequest?.commitChanges { (error) in
                        print("Created display name")
                    }
                }
                
            }
        }
        
    }
    
    func updatePassword(withUser user: User, andPassword newPassword: String, completion: @escaping (Error?) -> Void) {
        self.currentUser = user
        
        //reauthenticateUser(email: <#T##String#>, password: <#T##String#>, completion: <#T##(Error?) -> Void#>)
        reauthenticateUser(email: user.emailAddress, password: user.password) { (error) in
            if let error = error {
                print("Error reauthentication in updatePassword method: \(error)")
                return
            }
            self.serverCurrentUser?.updatePassword(to: newPassword, completion: completion)
            /*self.serverCurrentUser?.updatePassword(to: newPassword, completion: { (error) in
                if let error = error {
                    print("Error updating password: \(error)")
                    completion(error)
                    return
                }
            })*/
        }
        
        
    }
    
    func reauthenticateUser(email:String, password:String, completion: @escaping (Error?) -> Void) {
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        //prompt user to re-enter info
        
        user?.reauthenticateAndRetrieveData(with: credential, completion: { (_, error) in
            if error != nil {
                print("Error reauthenticating user: \(error)")
                return
            }
            else {
                print("User reauthenticated!")
                completion(nil)
            }
            
        })
        
       completion(nil)
    }

    
    func updatePasswordLocal(withUser user: User, andPassword newPassword: String) {
        
        user.password = newPassword
        putUserToServer(user: user)
    }
    
    func updateUserInfo(withUser user: User, rewardPoints: Int, orderId: String) {
        user.rewardPoints += rewardPoints
        user.orderIds.append(orderId)
        
        putUserToServer(user: user)
       
    }
    
    func updateMoltinUID(withUser user: User, id: String) {
        user.moltinUID = id
        
        putUserToServer(user: user)
    }
    
    func login(withEmail email: String, andPassword password: String, completion: @escaping (Error?) -> Void) {
        
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                if let error = error {
                    NSLog("Error finding user account: \(error)")
                    completion(error)
                    return
                }
                
                if let userAccount = user {
                    self.userFound = true
                    self.fetchSingleEntryFromServer(userId: userAccount.user.uid, completion: completion)
                }
            }
    }
    
    func putUserToServer(user: User, completion: @escaping (Error?) -> Void = {_ in }) {
        
        let identifier = user.uid
        
        let urlPlusId = baseURL.appendingPathComponent(identifier)
        let urlPlusJSON = urlPlusId.appendingPathExtension("json")
        
        var request = URLRequest(url: urlPlusJSON)
        request.httpMethod = "PUT"
        
        do {
            let encoder = JSONEncoder()
            let userJSON = try encoder.encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding error: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error putting entry to the server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
        
    }
    
    func fetchSingleEntryFromServer(userId: String, completion: @escaping (Error?) -> Void = {_ in }) {
        
        let identifier = userId
            
        let urlPlusId = baseURL.appendingPathComponent(identifier)
        let urlPlusJSON = urlPlusId.appendingPathExtension("json")
        
        var request = URLRequest(url: urlPlusJSON)
        request.httpMethod = "GET"
            
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching entry from server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from the server")
                completion(NSError())
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let userFromServer = try decoder.decode(User.self, from: data)
                self.currentUser = userFromServer
                print("The current user is: \(self.currentUser!.fullName)")
                let cust = CheckoutCustomer(emailAddress: self.currentUser!.emailAddress, name: self.currentUser!.fullName)
                self.customer = cust
                
                print("Customer from login: \(self.customer!)")
                
                completion(nil)
                
            } catch {
                NSLog("Error decoding user representation: \(error)")
                completion(error)
            }
            
        }.resume()
            
    }
    
    var token: String = ""
    
    
    func updateMoltinCustomerPassword(customerID: String, password: String, completion: @escaping (Error?) -> Void = {_ in }) {
        
        struct moltinToken: Codable {
            var clientID: String
            var token: String
            var expires: Date
        }
        if let data = UserDefaults.standard.value(forKey: "Moltin.auth.credentials") as? Data {
            let credentials = try? JSONDecoder().decode(moltinToken.self, from: data)
            token = credentials?.token ?? ""
        }
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        let user = ["data": [
            "type": "customer",
            "password": password
            ]] as [String : Any]
        
        let userData: Data
        do {
            userData = try JSONSerialization.data(withJSONObject: user, options: [])
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.moltin.com/v2/customers/:\(customerID)")! as URL,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        request.httpBody = userData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
            }
            completion(nil)
        })
        
        dataTask.resume()
    }
    
    func generateMoltinToken(email: String, password: String, completion: @escaping (Error?) -> Void = {_ in }) {
        
        struct moltinToken: Codable {
            var clientID: String
            var token: String
            var expires: Date
            
        }
        struct dataCustomer: Decodable {
            
            enum CodingKeys: String, CodingKey {
                case dataMoltin = "data"
            }
            var dataMoltin: [String: Any]
          
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let dataContainer = try container.decode([String: Any].self, forKey: .dataMoltin)
               
                self.dataMoltin = dataContainer
            }
        }
        if let data = UserDefaults.standard.value(forKey: "Moltin.auth.credentials") as? Data {
            let credentials = try? JSONDecoder().decode(moltinToken.self, from: data)
            token = credentials?.token ?? ""
        }
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        let user = ["data": [
            "type": "token",
            "password": password,
            "email": email,
            ]] as [String : Any]
        
        let userData: Data
        do {
            userData = try JSONSerialization.data(withJSONObject: user, options: [])
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.moltin.com/v2/customers/tokens")! as URL,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = userData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                do {
                     let decoder = JSONDecoder()
                     let userFromMoltin = try decoder.decode(dataCustomer.self, from: data!)
                   
                   // self.currentUser!.moltinUID = userFromMoltin.dataMoltin["customer_id"] as! String
                    self.token = userFromMoltin.dataMoltin["token"] as! String
                     print("The current user token: \(self.token)")
                    
                     completion(nil)
                 
                 } catch {
                     NSLog("Error decoding user token: \(error)")
                     completion(error)
                 }
                print(httpResponse as Any)
            }
            completion(nil)
        })
        
        dataTask.resume()
    }
    
    
    public func createMoltinCustomer(userName: String, userEmail: String, password: String, completion: @escaping (Error?) -> Void = {_ in }) {
      //  var credToken: String = ""
        struct moltinToken: Codable {
            var clientID: String
            var token: String
            var expires: Date
            
        }
        struct dataCustomer: Decodable {
            
            enum CodingKeys: String, CodingKey {
                case dataMoltin = "data"
            }
            var dataMoltin: [String: Any]
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let dataContainer = try container.decode([String: Any].self, forKey: .dataMoltin)
                
                self.dataMoltin = dataContainer
            }
        }
        
        if let data = UserDefaults.standard.value(forKey: "Moltin.auth.credentials") as? Data {
            let credentials = try? JSONDecoder().decode(moltinToken.self, from: data)
            token = credentials?.token ?? ""
        }
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        let user = ["data": [
            "type": "customer",
            "name": userName,
            "email": userEmail,
            "password": password
            ]] as [String : Any]
       
        let userData: Data
        do {
            userData = try JSONSerialization.data(withJSONObject: user, options: [])
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.moltin.com/v2/customers")! as URL,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = userData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(data as Any)
                do {
                    let decoder = JSONDecoder()
                    let userFromMoltin = try decoder.decode(dataCustomer.self, from: data!)
                    
                    self.updateMoltinUID(withUser: self.currentUser!, id: userFromMoltin.dataMoltin["id"] as! String)
                    print("The current user ID: \(self.currentUser!.moltinUID)")
                    
                    completion(nil)
                } catch {
                    NSLog("Error decoding user id: \(error)")
                    completion(error)
                }
                
                print(httpResponse as Any)
            }
            completion(nil)
        })
        
        dataTask.resume()
    }
    
    
    
 /*   func saveToPersistentStore() {
        guard let url = persistentFileURL else { return }
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(currentUser)
            try data.write(to: url)
        } catch {
            print(error)
        }
    }
    
    func loadToPersistentStore() {
        guard let url = persistentFileURL, FileManager.default.fileExists(atPath: url.path) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            currentUser = try decoder.decode(currentUser.self, from: data)
            
        } catch {
            print(error)
        }
    }
    
    private var persistentFileURL: URL? {
        let fileManager = FileManager.default
        
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask) else { return nil }
        
        let finalLocation = documentsDirectory.appendingPathComponent("type)
    }*/
    
    
    
    // completion: @escaping (Error?) -> Void = {_ in }
}


struct JSONCodingKeys: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}


extension KeyedDecodingContainer {
    
    func decode(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any> {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }
    
    func decodeIfPresent(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }
    
    func decode(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any> {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }
    
    func decodeIfPresent(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }
    
    func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()
        
        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}

extension UnkeyedDecodingContainer {
    
    mutating func decode(_ type: Array<Any>.Type) throws -> Array<Any> {
        var array: [Any] = []
        while isAtEnd == false {
            // See if the current value in the JSON array is `null` first and prevent infite recursion with nested arrays.
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode(Array<Any>.self) {
                array.append(nestedArray)
            }
        }
        return array
    }
    
    mutating func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}
