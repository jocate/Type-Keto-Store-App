//
//  User.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/18/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import Foundation

class User: Codable {
    
    static private let uidKey = "identifier"
    static private let nameKey = "fullName"
    static private let emailKey = "emailAddress"
    static private let passwordKey = "password"
    static private let rewardsKey = "rewardPoints"
    
    var emailAddress: String
    var password: String
    var fullName: String
   // var orders: [Order]
    var uid: String
    var rewardPoints: Int
    
    init(emailAddress: String, password: String, fullName: String, uid: String, rewardPoints: Int = 0) {
        self.emailAddress = emailAddress
        self.password = password
        self.fullName = fullName
        self.uid = uid
        self.rewardPoints = rewardPoints
    }
    
    var dictionaryRepresentation: [String: String] {
        return [User.emailKey: emailAddress, User.passwordKey: password, User.nameKey: fullName, User.uidKey: uid, User.rewardsKey: String(rewardPoints)]
    }
    
    convenience init?(dictionary: [String: String] /*, orders: [Order] = []*/) {
        guard let emailAddress = dictionary[User.emailKey], let password = dictionary[User.passwordKey], let fullName = dictionary[User.nameKey], let uid = dictionary[User.uidKey], let rewardPoints = dictionary[User.rewardsKey] else { return nil }
        
        self.init(emailAddress: emailAddress, password: password, fullName: fullName, uid: uid, rewardPoints: Int(rewardPoints)!)
    }
    
}
