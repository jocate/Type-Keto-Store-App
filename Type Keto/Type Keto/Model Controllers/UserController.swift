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

class UserController {
    
    var userFound: Bool = false
    var serverCurrentUser = Auth.auth().currentUser
    var currentUser: User?
    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
   // private let userRef = Database.database().reference().child("users")
    let baseURL = URL(string: "https://type-keto-store.firebaseio.com/")!
    
    func createUserAccount(withEmail email: String, andPassword password: String, andName fullName: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                NSLog("Error creating user account: \(error)")
            }
            
            if let userAccount = user {
               
                let userLocal = User(emailAddress: userAccount.user.email!, password: password, fullName: fullName, uid: userAccount.user.uid)
                if Auth.auth().currentUser?.uid == userLocal.uid {
            
                    self.currentUser = userLocal
                    self.putUserToServer(user: userLocal)
                    self.changeRequest?.displayName = userLocal.fullName
                    self.changeRequest?.commitChanges { (error) in
                        print("Created display name")
                    }
                }
                
            }
        }
        
    }
    
    func login(withEmail email: String, andPassword password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                NSLog("Error creating user account: \(error)")
            }
            
            if let userAccount = user {
                self.userFound = true
                self.fetchSingleEntryFromServer(userId: userAccount.user.uid)
               // print("The current user is: \(self.currentUser)")
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
                
            } catch {
                NSLog("Error decoding user representation: \(error)")
                completion(error)
            }
            
        }.resume()
            
    }
        
    
    
    
    // completion: @escaping (Error?) -> Void = {_ in }
}
