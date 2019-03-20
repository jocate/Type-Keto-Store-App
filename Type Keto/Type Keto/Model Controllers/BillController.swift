//
//  BillController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/19/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import Foundation

//TODO: calculate rewards points, add rewards points to user, update user on server, create a bill, leave room for stripe

class BillController {
    
    
    var newRewardPoints = Int()
    var currentBill: Bill?
    
    func calculateRewards(purchaseAmount: Double) {
        
        let roundedNum = purchaseAmount.rounded()
        
        newRewardPoints = Int(roundedNum)
    
    }
    
    func createBill(purchaseAmount: Double, purchaseWithTaxes: Double, purchaseWithShipping: Double, totalAmountCharged: Double) {
        
        let bill = Bill(purchaseAmount: purchaseAmount, purchaseWithTaxes: purchaseWithTaxes, purchaseWithShipping: purchaseWithShipping, totalAmountCharged: totalAmountCharged)
        
        currentBill = bill
        
    }
    
    
    
    
}
