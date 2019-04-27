//
//  Bill.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/19/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import Foundation

class Bill: Codable, Equatable {
    static func == (lhs: Bill, rhs: Bill) -> Bool {
        return rhs.purchaseAmount == lhs.purchaseAmount
    }
    
    
    var purchaseAmount: Double
   // var purchaseWithDiscount: Double
    var purchaseWithTaxes: Double
    var purchaseWithShipping: Double
    var totalAmountCharged: Double
    
    init(purchaseAmount: Double, purchaseWithTaxes: Double, purchaseWithShipping: Double, totalAmountCharged: Double) {
        
        self.purchaseAmount = purchaseAmount
        self.purchaseWithTaxes = purchaseWithTaxes
        self.purchaseWithShipping = purchaseWithShipping
        self.totalAmountCharged = totalAmountCharged
        
    }
    
    
    
}
