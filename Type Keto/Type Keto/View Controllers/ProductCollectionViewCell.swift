//
//  ProductCollectionViewCell.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/19/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    
    var product: Product? {
        didSet {
            updateViews()
        }
    }
    
    let productController = ProductController()
    
    func updateViews() {
        guard let product = product else { return }
        
        productImageView.image = UIImage(data: product.image)
        productNameLabel.text = product.name
        productSizeLabel.text = product.size
        productDetailLabel.text = "\(product.numOfFlavors) flavors"
        productPriceLabel.text = String(product.price)
        
        
    }
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productAddButton: UIButton!
    
    @IBAction func addToCartTapped(_ sender: UIButton) {
        guard let product = product else { return }
        productController.addProductToCart(withProduct: product) { (error) in
            if let error = error {
                NSLog("Error adding product to cart: \(error)")
                
            }
           
        }
        
    }
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productSizeLabel: UILabel!
    
    @IBOutlet weak var productDetailLabel: UILabel!
    
    @IBOutlet weak var productPriceLabel: UILabel!
}
