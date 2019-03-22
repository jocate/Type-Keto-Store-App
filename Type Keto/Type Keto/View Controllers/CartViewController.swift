//
//  CartViewController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/19/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit
import moltin

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let moltin: Moltin = Moltin(withClientID: "rxlE4z2FEDFv8YJdPN0GC9wzclQITMemsoathUB4Vt")
    
    var cartItems: [CartItem] = []
    
   // var productController: ProductController?
    var user: User?
    
    let userController = UserController()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Within the table view: \(self.cartItems.count)")
        return self.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        
        let cartItem = self.cartItems[indexPath.row]
        cell.priceLabel.text = "$\(cartItem.meta.displayPrice.withoutTax)"
        cell.productNameLabel.text = cartItem.name
        
        // at the moment you cannot change the quantity from 1
        
        return cell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCart()
        cartTableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    } */
    
     @IBOutlet weak var cartTableView: UITableView!
 
    
    
    func updateCart() {
        guard isViewLoaded else { return }
        
        var purchaseAmount = Double()
      /*  for item in cartItems {
           purchaseAmount += Double(item.meta.displayPrice.withoutTax.)
        }
        let purchaseAmount = self.moltin.cart.
        let purchaseWithTaxes = billController.calculatePurchaseWithTaxes(purchaseAmount: purchaseAmount)
        let shippingCost = billController.shippingCost
        let totalCharged = billController.calcTotalCharged(purchaseWithTaxes: purchaseWithTaxes)
        
        purchaseAmountLabel.text = "$\(purchaseAmount)"
        
        purchaseWithTaxesLabel.text = "$\(purchaseWithTaxes)"
        purchaseWithShippingLabel.text = "$\(shippingCost)"
        totalChargedLabel.text = "$\(totalCharged)"*/
        
        
    }
    
    @IBOutlet weak var purchaseAmountLabel: UILabel!
    @IBOutlet weak var purchaseWithTaxesLabel: UILabel!
    
    
    @IBOutlet weak var purchaseWithShippingLabel: UILabel!
    
    @IBOutlet weak var totalChargedLabel: UILabel!
    
    var chargeToken = String()
    
    @IBAction func checkoutTapped(_ sender: UIBarButtonItem) {
        
        if userController.currentUser?.rewardPoints == 250 && (userController.currentUser?.rewardPoints)! < 500 {
            self.moltin.cart.addPromotion("250TKRewards", toCart: userController.cartID) { (result) in
                switch result {
                case .success(let status):
                    DispatchQueue.main.async {
                        print("Promotion: \(status)")
                    }
                default: break
                }
            }
            
        }
        
        
        
       
    }
    

}
