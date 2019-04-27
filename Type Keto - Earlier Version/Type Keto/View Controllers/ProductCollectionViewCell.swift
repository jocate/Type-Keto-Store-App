//
//  ProductCollectionViewCell.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/19/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit
import moltin

class ProductCollectionViewCell: UICollectionViewCell {
    
    let moltin: Moltin = Moltin(withClientID: "rxlE4z2FEDFv8YJdPN0GC9wzclQITMemsoathUB4Vt")
    
  //  let productController = ProductController()
    let userController = UserController()
    
    var product: Product? 
    
    func updateViews() {
        guard let product = product else { return }
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeCover(notification:)), name: .coverAdded, object: nil)
        
        if isAdded == false {
            DispatchQueue.main.async {
                self.addedProductCoverView.alpha = 0
            }
        } else {
            DispatchQueue.main.async {
                self.addedProductCoverView.alpha = 0.85
            }
        }
      
    }
    
    @objc func removeCover(notification: NSNotification) {
        DispatchQueue.main.async {
            self.addedProductCoverView.alpha = 0
        }
    }
    
    var isAdded: Bool = false
    @IBOutlet weak var addedProductCoverView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productAddButton: UIButton!
    
    @IBAction func addToCartTapped(_ sender: UIButton) {
        guard let product = product else { return }
       // print("About to add to cart")
        print("Product Id: \(product.id)")
        print("Cart Id: \(AppDelegate.cartID)")
        self.moltin.cart.addProduct(withID: product.id, ofQuantity: 1, toCart: AppDelegate.cartID) { (result) in
            switch result {
            case .success:
                print("Added a product to the cart")
                self.isAdded = true
                self.updateViews()
            case .failure(let error):
                print("Error adding a product to the cart: \(error)")
            }
        }
        
    }
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productSizeLabel: UILabel!
    
    @IBOutlet weak var productDetailLabel: UILabel!
    
    @IBOutlet weak var productPriceLabel: UILabel!
}

