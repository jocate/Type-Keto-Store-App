//
//  GuestUser.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 4/22/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import Foundation

class GuestUser: Codable {
    
    var emailAddress: String
    var fullName: String
    var moltinUID: String
    var orderIds: [String] //Do cart IDs = order Ids on moltin?
    
    init(emailAddress: String, fullName: String, moltinUID: String = UUID().uuidString, orderIds: [String] = ["None"]/* orderHistory: [Order] = []*/) {
        self.emailAddress = emailAddress
        self.fullName = fullName
        self.moltinUID = moltinUID
        self.orderIds = orderIds
    }
    
    
    
    
}
