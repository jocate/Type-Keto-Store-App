//
//  ShipmentDetailsViewController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/21/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit
import moltin

var billingAddress: Address?
var shippingAddress: Address?

class ShipmentDetailsViewController: UIViewController {
    
    let moltin: Moltin = Moltin(withClientID: "rxlE4z2FEDFv8YJdPN0GC9wzclQITMemsoathUB4Vt")
    
    let userController = UserController()
    var sameAddress: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Billing Address Info
    
    @IBOutlet weak var firstNameLabel: UITextField!
    
    @IBOutlet weak var lastNameLabel: UITextField!
    
    @IBOutlet weak var streetLabel: UITextField!
    
    @IBOutlet weak var cityLabel: UITextField!
    
    @IBOutlet weak var zipcodeLabel: UITextField!
    
    @IBOutlet weak var countryLabel: UITextField!
    
    
    // Shipping Address Info
    
    @IBOutlet weak var sameAddressButton: UIButton!
    
    @IBAction func sameAddressTapped(_ sender: UIButton) {
        if sameAddressButton.titleLabel!.text == "Same as Billing Address"{
            sameAddress = true
            sameAddressButton.setTitle("Added!", for: .normal)
            sameAddressButton.setTitleColor(.gray, for: .normal)
            
            firstNameShippingLabel.alpha = 0
            lastNameLabel.alpha = 0
            streetShippingLabel.alpha = 0
            cityShippingLabel.alpha = 0
            zipcodeShippingLabel.alpha = 0
            countryShippingLabel.alpha = 0
        }
        if sameAddressButton.titleLabel!.text == "Added!"{
            sameAddress = true
            sameAddressButton.setTitle("Same as Billing Address", for: .normal)
            sameAddressButton.setTitleColor(.blue, for: .normal)
            
            firstNameShippingLabel.alpha = 1
            lastNameLabel.alpha = 1
            streetShippingLabel.alpha = 1
            cityShippingLabel.alpha = 1
            zipcodeShippingLabel.alpha = 1
            countryShippingLabel.alpha = 1
        }
        
    }
    
    @IBOutlet weak var firstNameShippingLabel: UITextField!
    
    
    @IBOutlet weak var lastNameShippingLabel: UITextField!
    
    @IBOutlet weak var streetShippingLabel: UITextField!
    
    @IBOutlet weak var cityShippingLabel: UITextField!
    
    @IBOutlet weak var zipcodeShippingLabel: UITextField!
    
    @IBOutlet weak var countryShippingLabel: UITextField!
    
    
    
    @IBAction func checkoutTapped(_ sender: UIBarButtonItem) {
        
        if sameAddress == true {
            guard let firstNameBilling = firstNameLabel.text, let lastNameBilling = lastNameLabel.text, let streetBilling = streetLabel.text, let cityBilling = cityLabel.text, let zipcodeBilling = zipcodeLabel.text, let countryBilling = countryLabel.text else { return }
            
            shippingAddress = nil
            
            billingAddress = Address(withFirstName: firstNameBilling, withLastName: lastNameBilling)
            billingAddress!.line1 = streetBilling
            billingAddress!.city = cityBilling
            billingAddress!.country = countryBilling
            billingAddress!.postcode = zipcodeBilling
        
        } else {
            guard let firstNameBilling = firstNameLabel.text, let lastNameBilling = lastNameLabel.text, let streetBilling = streetLabel.text, let cityBilling = cityLabel.text, let zipcodeBilling = zipcodeLabel.text, let countryBilling = countryLabel.text, let firstNameShipping = firstNameShippingLabel.text, let lastNameShipping = lastNameShippingLabel.text, let streetShipping = streetShippingLabel.text, let cityShipping = cityShippingLabel.text, let zipcodeShipping = zipcodeShippingLabel.text, let countryShipping = countryShippingLabel.text else { return }
            
            shippingAddress = Address(withFirstName: firstNameShipping, withLastName: lastNameShipping)
            shippingAddress!.line1 = streetShipping
            shippingAddress!.city = cityShipping
            shippingAddress!.country = countryShipping
            shippingAddress!.postcode = zipcodeShipping
            
            billingAddress = Address(withFirstName: firstNameBilling, withLastName: lastNameBilling)
            billingAddress!.line1 = streetBilling
            billingAddress!.city = cityBilling
            billingAddress!.country = countryBilling
            billingAddress!.postcode = zipcodeBilling
        }
        
       
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // FromShippingToPay  Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
