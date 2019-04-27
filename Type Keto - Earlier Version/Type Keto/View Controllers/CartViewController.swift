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
    // find a way to update the total labels below the cart, so user can see totals
    
    
    var user: User?
    
    var userController: UserController?
    var rewardsPoints: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCart(notification:)), name: .update, object: nil)
        continueButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Typo Grotesk Thin", size: 17)!], for: UIControl.State.normal)
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Typo Grotesk", size: 17)!], for: UIControl.State.normal)
        //self.cartTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
       // updateCart()
        self.moltin.cart.items(forCartID: AppDelegate.cartID) { (result) in
            switch result {
            case .success(let result):
                print("Cart in viewWillAppear: \(result.data)")
                DispatchQueue.main.async {
                    self.cartItems = result.data ?? []
                    self.cartTableView.reloadData()
                }
            case .failure(let error):
                print("Erorr fetching cart items: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print("Within the table view: \(self.cartItems.count)")
        return self.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        
        let cartItem = self.cartItems[indexPath.row]
        cell.priceLabel.text = (cartItem.meta.displayPrice.withTax.value.formatted)
        
        cell.productNameLabel.text = cartItem.name
        print("Cache: \(productImageCache[cartItem.name]), Name: \(cartItem.name)")
       // cell.productImageView.image = UIImage(data: productImageCache[cartItem.name]!, scale: 1)
        
        cell.product = cartItem
        // at the moment you cannot change the quantity from 1
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = self.cartItems[indexPath.row]
            
            self.moltin.cart.removeItem(product.id, fromCart: AppDelegate.cartID) { (result) in
                switch result {
                case .success(let status):
                    print("Successfully deleted item")
                    DispatchQueue.main.async {
                        
                        self.cartItems = status
                        self.cartTableView.reloadData()
                        NotificationCenter.default.post(name: .update, object: nil)
                    }
                case .failure(let error):
                    print("Could not delete \(product) from moltin: \(error)")
                }
            }
            NotificationCenter.default.post(name: .coverAdded, object: nil)
        }
    }
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromCartToShip" {
            let destinationVC = segue.destination as! ShipmentDetailsViewController
            
            
            destinationVC.user = user
            destinationVC.rewardPoints = rewardsPoints
            // destinationVC.productController = productController
        }
    }
    
    @objc func updateCart(notification: NSNotification) {
        //guard isViewLoaded else { return }
        print("Received the notification to update cart labels")
        self.moltin.cart.items(forCartID: AppDelegate.cartID) { (result) in
            switch result {
            case .success(let result):
                print("Cart in viewWillAppear: \(result.data)")
                DispatchQueue.main.async {
                    self.cartItems = result.data ?? []
                    self.cartTableView.reloadData()
                }
            case .failure(let error):
                print("Erorr fetching cart items: \(error)")
            }
        }
        DispatchQueue.main.async {
            var purchaseAmount = Double()
            //purchaseAmountLabel.text = self.moltin.cart.
            for item in self.cartItems {
                purchaseAmount += Double(item.meta.displayPrice.withoutTax.value.amount)
            }
            // let purchaseAmount = self.moltin.cart.
            //let purchaseWithTaxes = billController.calculatePurchaseWithTaxes(purchaseAmount: purchaseAmount)
            let shippingCost = self.billController.shippingCost
            let totalCharged = shippingCost + (purchaseAmount/100)
            
            self.purchaseAmountLabel.text = "$\(purchaseAmount/100)"
            
            // purchaseWithTaxesLabel.text = "$\(purchaseWithTaxes)"
            self.purchaseWithShippingLabel.text = "$\(shippingCost)"
            self.totalChargedLabel.text = "$\(totalCharged)"
            //self.cartTableView.reloadData()
            self.rewardsPoints = Int(purchaseAmount * 2)
        }
        
    
    }
    @IBOutlet weak var continueButton: UIBarButtonItem!
    
     @IBOutlet weak var cartTableView: UITableView!
 
    @IBOutlet weak var purchaseAmountLabel: UILabel!
   
    @IBOutlet weak var purchaseWithShippingLabel: UILabel!
    
    @IBOutlet weak var totalChargedLabel: UILabel!
    
    var chargeToken = String()
    let billController = BillController()
    
    var shippingCustomItem = CustomCartItem(withName: "Flat Rate Shipping", sku: "flat-rate-shipping", quantity: 1, description: "Flat rate shipping charge", price: CartItemPrice(amount: 599, includes_tax: true))
    
    @IBAction func checkoutTapped(_ sender: UIBarButtonItem) {
        
        if userController?.currentUser?.rewardPoints == 250 && (userController?.currentUser?.rewardPoints)! < 500 {
            print("25% off applies to this order!")
            self.moltin.cart.addPromotion("250TKRewards", toCart: AppDelegate.cartID) { (result) in
                switch result {
                case .success(let status):
                    DispatchQueue.main.async {
                        print("Promotion: \(status)")
                    }
                default: break
                }
            }
            
        }
        self.moltin.cart.addCustomItem(shippingCustomItem, toCart: AppDelegate.cartID) { (result) in
            switch result {
            case .success(let status):
                DispatchQueue.main.async {
                    print("Shipping added successfully!: \(status)")
                    self.performSegue(withIdentifier: "FromCartToShip", sender: self)
                }
            default: break
            }
        }
        
        
       
    }
    

}
