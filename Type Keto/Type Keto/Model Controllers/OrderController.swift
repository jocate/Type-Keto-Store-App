//
//  OrderController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/19/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import Foundation

/*class OrderController {
    
    let userController = UserController()
    
    func createOrder(withCart cart: Cart, user: User, bill: Bill, rewardPoints: Int, shippingAddress: String, lastDigits: String) {
        
        var order = Order(products: cart, user: user, rewardPoints: rewardPoints, shippingAddress: shippingAddress, lastFourDigitsOfCard: lastDigits)
        
       // userController.currentUser?.orderHistory?.append(order)
        
       userController.updateUserInfo(withUser: user, rewardPoints: rewardPoints, newOrder: order)
        
        // TODO: update the server with this new information, leave room for sttripe, edit order - shipping address and/or cart items, and cancel order
        
    }
    
    func editOrder(withOrder order: Order, andUser user: User, shippingAddress: String) {
        
        if order.user.uid == user.uid {
            order.shippingAddress = shippingAddress
            
            
        }
        
    }
    
    func deleteOrder(order: Order, user: User) {
        var index: Int
        
        for o in user.orderHistory! {
            if o.orderId == order.orderId {
                index = user.orderHistory!.firstIndex(of: o)!
                userController.currentUser?.orderHistory!.remove(at: index)
            }
        }
      
    }
    
    func cancelOrder() {}
    
    
    
}*/
