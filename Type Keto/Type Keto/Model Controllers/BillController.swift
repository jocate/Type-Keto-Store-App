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
    var freeShipping: Bool = false
    let shippingCost = 5.95
    
    func calculateRewards(purchaseAmount: Double) {
        
        let roundedNum = purchaseAmount.rounded()
        
        newRewardPoints = Int(roundedNum)
    
    }
    
    func createBill(purchaseAmount: Double, purchaseWithTaxes: Double, purchaseWithShipping: Double, totalAmountCharged: Double) {
        
        let bill = Bill(purchaseAmount: purchaseAmount, purchaseWithTaxes: purchaseWithTaxes, purchaseWithShipping: purchaseWithShipping, totalAmountCharged: totalAmountCharged)
        
        currentBill = bill
        
    }
    
   /* func calculatePurchaseAmount(cart: [Product]) -> Double {
        var total = Double()
        
        for product in cart {
            total += (product.price * Double(product.quantity ?? 1))
        }
        
        return total
        
    }*/
    
    func calculatePurchaseWithTaxes(purchaseAmount: Double) -> Double {
        let taxPercentage = 0.06
        let withTax = (purchaseAmount * taxPercentage)
        
        return (purchaseAmount + withTax)
    }
   
    
    func calcTotalCharged(purchaseWithTaxes: Double) -> Double {
        
        var totalCharged = Double()
        
        if freeShipping == true {
            totalCharged = purchaseWithTaxes
           // return totalCharged
        } else {
            totalCharged = shippingCost + purchaseWithTaxes
        }
        
        return totalCharged
        
    }
    
}
