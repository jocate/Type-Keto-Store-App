//
//  CartTableViewCell.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/20/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit
import moltin

class CartTableViewCell: UITableViewCell {
    
    let moltin: Moltin = Moltin(withClientID: "rxlE4z2FEDFv8YJdPN0GC9wzclQITMemsoathUB4Vt")

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 //   let productController = ProductController()
    var product: CartItem? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let product = product else { return }
     
      //  let price = product.price
        
       // priceLabel.text = "$\(price)"
        DispatchQueue.main.async {
            self.quantityLabel.text = "Quantity: \(self.quantity)"
        }
        
     //   productImageView.image = UIImage(data: product.image)
      //  productNameLabel.text = product.name
     
    }
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    var quantity = 1
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        guard let product = product else { return }
        
        quantity = Int(sender.value)
        
        self.moltin.cart.updateItem(product.id, withQuantity: quantity, inCart: AppDelegate.cartID) { (result) in
            
            switch result {
            case .success:
                print("Successfully updated item quantity")
                DispatchQueue.main.async {
                    self.updateViews()
                }
            case .failure(let error):
                print("Could not update item quantity: \(error)")
            }
        }
        
      
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let product = product else { return }
        
        //removeItem
    }
    
    

}
