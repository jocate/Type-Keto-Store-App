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
    
   /* func updateViews() {
        guard let product = product else { return }
        
       productImageView.image = UIImage(data: product.image)
        productNameLabel.text = product.name
        productSizeLabel.text = product.size
        productDetailLabel.text = "\(product.numOfFlavors) flavors"
        productPriceLabel.text = String(product.price)
        
        
    }*/
    
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productAddButton: UIButton!
    
    @IBAction func addToCartTapped(_ sender: UIButton) {
        guard let product = product else { return }
        
        self.moltin.cart.addProduct(withID: product.id, ofQuantity: 1, toCart: userController.cartID) { (result) in
            switch result {
            case .success:
                print("Added a product to the cart")
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
