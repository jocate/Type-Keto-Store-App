//
//  ShipmentDetailsViewController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/21/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit
import moltin
import Stripe

var billingAddress: Address?
var shippingAddress: Address?

class ShipmentDetailsViewController: UIViewController, STPAddCardViewControllerDelegate {
    
    let moltin: Moltin = Moltin(withClientID: "rxlE4z2FEDFv8YJdPN0GC9wzclQITMemsoathUB4Vt")
    
    let userController = UserController()
    var sameAddress: Bool = false
    
    var paymentToken: String? {
        didSet {
        
            
        }
    }
    
    var user: User?
    var guest: Bool = false
    var rewardPoints: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user?.emailAddress == "guest@guest.com" {
            showGuestUI()
        } else {
            emailAddressLabel.alpha = 0
        }
        //UINavigationBar.appearance()
        checkoutButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Typo Grotesk Thin", size: 17)!], for: UIControl.State.normal)
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Typo Grotesk", size: 17)!], for: UIControl.State.normal)
        NotificationCenter.default.addObserver(self, selector: #selector(showGuestEmailField(notification:)), name: .guestUI, object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
   @objc func showGuestEmailField(notification: NSNotification) {
        emailAddressLabel.alpha = 1
        guest = true
        print("Notification center spoke with my shipment detail page!")
    }
    
    func showGuestUI() {
        emailAddressLabel.alpha = 1
        guest = true
    }
    
    @IBOutlet weak var checkoutButton: UIBarButtonItem!
    // Billing Address Info
    
    @IBOutlet weak var firstNameLabel: UITextField!
    
    @IBOutlet weak var lastNameLabel: UITextField!
    
    @IBOutlet weak var streetLabel: UITextField!
    
    @IBOutlet weak var cityLabel: UITextField!
    
    @IBOutlet weak var zipcodeLabel: UITextField!
    
    @IBOutlet weak var countryLabel: UITextField!
    
    @IBOutlet weak var emailAddressLabel: UITextField!
    
    // Shipping Address Info
    
    @IBOutlet weak var sameAddressButton: UIButton!
    
    @IBAction func sameAddressTapped(_ sender: UIButton) {
        if sameAddressButton.titleLabel!.text == "Same as Billing Address"{
            sameAddress = true
            sameAddressButton.setTitle("Added!", for: .normal)
            sameAddressButton.setTitleColor(.gray, for: .normal)
            
            firstNameShippingLabel.alpha = 0
            lastNameShippingLabel.alpha = 0
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
            lastNameShippingLabel.alpha = 1
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
    
    var guestUserEmail = String()
    let guestUserController = GuestUserController()
    var guestCustomer: GuestUser?
    
    @IBAction func checkoutTapped(_ sender: UIBarButtonItem) {
        
        if sameAddress == true {
            guard let firstNameBilling = firstNameLabel.text, let lastNameBilling = lastNameLabel.text, let streetBilling = streetLabel.text, let cityBilling = cityLabel.text, let zipcodeBilling = zipcodeLabel.text, let countryBilling = countryLabel.text else { return }
            
            shippingAddress = nil
            
            billingAddress = Address(withFirstName: firstNameBilling, withLastName: lastNameBilling)
            billingAddress!.line1 = streetBilling
            billingAddress!.county = cityBilling
            billingAddress!.country = countryBilling
            billingAddress!.postcode = zipcodeBilling
            
            presentStripeCardViewController()
        
        } else {
            guard let firstNameBilling = firstNameLabel.text, let lastNameBilling = lastNameLabel.text, let streetBilling = streetLabel.text, let cityBilling = cityLabel.text, let zipcodeBilling = zipcodeLabel.text, let countryBilling = countryLabel.text, let firstNameShipping = firstNameShippingLabel.text, let lastNameShipping = lastNameShippingLabel.text, let streetShipping = streetShippingLabel.text, let cityShipping = cityShippingLabel.text, let zipcodeShipping = zipcodeShippingLabel.text, let countryShipping = countryShippingLabel.text else { return }
            
            shippingAddress = Address(withFirstName: firstNameShipping, withLastName: lastNameShipping)
            shippingAddress!.line1 = streetShipping
            shippingAddress!.county = cityShipping
            shippingAddress!.country = countryShipping
            shippingAddress!.postcode = zipcodeShipping
            
            billingAddress = Address(withFirstName: firstNameBilling, withLastName: lastNameBilling)
            billingAddress!.line1 = streetBilling
            billingAddress!.county = cityBilling
            billingAddress!.country = countryBilling
            billingAddress!.postcode = zipcodeBilling
            
            presentStripeCardViewController()
        
        }
       /* print("Number 1 Billing: \(billingAddress)")
        print("Number 1 Shipping: \(shippingAddress)") */
      //  self.performSegue(withIdentifier: "FromShippingToPay", sender: self)
        
        // TODO: Add logic that only transitions to STP when addresses != nil
   
    }
    
    func presentStripeCardViewController() {
        if guest == true {
            guard let guestEmail = emailAddressLabel.text else { return }
            
            guestUserEmail = guestEmail
            let fullName = "\(firstNameLabel.text) \(lastNameLabel.text)"
            guestCustomer = guestUserController.createGuestUser(withName: fullName, andEmail: guestEmail, andOrderID: AppDelegate.cartID)
            
            // MARK: Stripe Standard Card View Controller
            
            let addCardViewController = STPAddCardViewController()
            addCardViewController.delegate = self
            
            // Present add card view controller
            let navigationController = UINavigationController(rootViewController: addCardViewController)
            present(navigationController, animated: true)
            
        } else {
            
            // MARK: Stripe Standard Card View Controller
            
            let addCardViewController = STPAddCardViewController()
            addCardViewController.delegate = self
            
            // Present add card view controller
            let navigationController = UINavigationController(rootViewController: addCardViewController)
            present(navigationController, animated: true)
            
        }
        
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        dismiss(animated: true)
        
        print("Printing Strip response:\(token.allResponseFields)\n\n")
        print("Printing Strip Token:\(token.tokenId)")
        
        paymentToken = token.tokenId
        
        print("Stored variable: \(paymentToken)")
        
        // MARK: Cart Checkout Moltin
        let guestCheckoutCustomer = Customer(withEmail: guestCustomer?.emailAddress, withName: guestCustomer?.fullName)
        
       // let checkoutCustomer = Customer(withID: user!.moltinUID, withEmail: user!.emailAddress, withName: user!.fullName)
        
        let userCheckoutCust = Customer(withEmail: user!.emailAddress, withName: user!.fullName)
        
        var checkoutCustomer: Customer?
        
        if guest == true {
            checkoutCustomer = guestCheckoutCustomer
            print("Guest Customer")
        } else {
            checkoutCustomer = userCheckoutCust
            print("Customer with an account")
        }
        
        /* print("Bill: \(billingAddress!)")
         print("Ship: \(shippingAddress)")*/
        
        self.moltin.cart.checkout(cart: AppDelegate.cartID, withCustomer: checkoutCustomer!, withBillingAddress: billingAddress!, withShippingAddress: shippingAddress) { (result) in
            
            switch result {
            case .success(let order):
                DispatchQueue.main.async {
                    self.payForOrder(order: order)
                }
            case .failure(let error):
                print("Error checking out cart: \(error)")
            }
        }
        
        
    }
    
    func payForOrder(order: Order) {
       // guard let token = paymentToken! else { return }
        
      //  let paymentMethod = StripeCard(withFirstName: firstName, withLastName: lastName, withCardNumber: cardNumber, withExpiryMonth: month, withExpiryYear: year, withCVVNumber: cvv)
        
        print("Inside the pay: \(paymentToken!)")
        
        let paymentMethod = StripeToken(withStripeToken: paymentToken!)
        
        self.moltin.cart.pay(forOrderID: order.id, withPaymentMethod: paymentMethod) { (result) in
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.showOrderStatus(withSuccess: true)
                    if self.user?.orderIds[0] == "None" {
                        self.user?.orderIds.remove(at: 0)
                    }
                    self.userController.updateUserInfo(withUser: self.user!, rewardPoints: self.rewardPoints!, orderId: order.id)
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
            
            self.performSegue(withIdentifier: "PaymentToHome", sender: self)
        }
        
        if success == true {
            alert.addAction(returnHomeAction)
            NotificationCenter.default.post(name: .coverAdded, object: nil)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // FromShippingToPay  Get the new view controller using
        if segue.identifier == "FromShippingToPay" {
            let destinationVC = segue.destination as! PaymentViewController
            
            
            destinationVC.billingAdd = billingAddress
            destinationVC.shippingAdd = shippingAddress
            destinationVC.user = user
        // destinationVC.productController = productController
        }
    }*/
    

}
