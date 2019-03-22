//
//  PaymentViewController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/21/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit
import moltin

class PaymentViewController: UIViewController {

    let moltin: Moltin = Moltin(withClientID: "rxlE4z2FEDFv8YJdPN0GC9wzclQITMemsoathUB4Vt")
    
    let userController = UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var firstNameLabel: UITextField!
    
    @IBOutlet weak var lastNameLabel: UITextField!
    
    @IBOutlet weak var cardNumberLabel: UITextField!
    
    @IBOutlet weak var monthLabel: UITextField!
    
    @IBOutlet weak var yearLabel: UITextField!
    
    @IBOutlet weak var cvvLabel: UITextField!
    
    @IBAction func finishTapped(_ sender: UIBarButtonItem) {
        
        let checkoutCustomer = Customer(withID: userController.currentUser?.uid, withEmail: userController.customer?.emailAddress, withName: userController.customer?.name)
        
        self.moltin.cart.checkout(cart: userController.cartID, withCustomer: checkoutCustomer, withBillingAddress: billingAddress!, withShippingAddress: shippingAddress!) { (result) in
            
            switch result {
            case .success(let order):
                self.payForOrder(order: order)
            default: break
            }
        }
        
    }
    
    func payForOrder(order: Order) {
        guard let firstName = firstNameLabel.text, let lastName = lastNameLabel.text, let cardNumber = cardNumberLabel.text, let month = monthLabel.text, let year = yearLabel.text, let cvv = cvvLabel.text else { return }
        
        let paymentMethod = StripeCard(withFirstName: firstName, withLastName: lastName, withCardNumber: cardNumber, withExpiryMonth: month, withExpiryYear: year, withCVVNumber: cvv)
        
        self.moltin.cart.pay(forOrderID: order.id, withPaymentMethod: paymentMethod) { (result) in
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.showOrderStatus(withSuccess: true)
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showOrderStatus(withSuccess: false, withError: error)
                }
            }
        }
    }
    
    func showOrderStatus(withSuccess success: Bool, withError error: Error? = nil) {
        let title = success ? "Order paid!" : "Order error"
        let message = success ? "Complete!" : error?.localizedDescription
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let returnHomeAction = UIAlertAction(title: "Return Home", style: .default) { (_) in
            
            self.performSegue(withIdentifier: "FromPaymentToHome", sender: self)
        }
        
        if success == true {
            alert.addAction(returnHomeAction)
        }
        self.present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
