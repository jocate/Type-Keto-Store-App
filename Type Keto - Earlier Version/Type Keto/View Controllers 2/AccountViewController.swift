//
//  AccountViewController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 4/23/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit
import moltin
import FirebaseAuth


class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let moltin: Moltin = Moltin(withClientID: "rxlE4z2FEDFv8YJdPN0GC9wzclQITMemsoathUB4Vt")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Typo Grotesk", size: 17)!], for: UIControl.State.normal)
        signOutButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Typo Grotesk Thin", size: 17)!], for: UIControl.State.normal)
        self.coverView.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    
    @IBAction func signoutButtonTapped(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "firstNavigationController") as! UINavigationController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    var user: User?
    var userController: UserController?
    let dateFormatter = DateFormatter()
    
    // segue id: ToAccount
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderDetails" {
            guard let destinationVC = segue.destination as? OrderHistoryDetailViewController, let cell = sender as? AccountOrderHistoryTableViewCell else { return }
            
            destinationVC.user = user
            
           /* destinationVC.orderIDLabel.text = cell.orderID
            destinationVC.timestampLabel.text = cell.orderDate
            destinationVC.paymentAmountLabel.text = cell.orderPaymentTotal
            destinationVC.paymentStatusLabel.text = cell.orderPaymentStatus
            destinationVC.shippingAddressLabel.text = cell.orderShippingAddress
            destinationVC.shippingStatusLabel.text = cell.orderShippingStatus */
            //destinationVC.itemsLabel.text = cell.orderItems
            
            destinationVC.orderIDLabel.text = orderID
            destinationVC.timestampLabel.text = orderDate
            destinationVC.paymentAmountLabel.text = orderPaymentTotal
            destinationVC.paymentStatusLabel.text = orderPaymentStatus
            destinationVC.shippingAddressLabel.text = orderShippingAddress
            destinationVC.shippingStatusLabel.text = orderShippingStatus
            
        }
    }
    
    
    // MARK: UIView Properties
    
    @IBOutlet weak var coverView: UIView!
    
    // MARK: Change Password Properties
    @IBOutlet weak var oldPasswordTextField: UITextField!
   
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var updatePasswordButton: UIButton!
    
    @IBAction func updatePasswordButtonTapped(_ sender: UIButton) {
        if let oldPw = oldPasswordTextField.text, let newPw = newPasswordTextField.text, let confirmPw = confirmPasswordTextField.text {
            
            if oldPw == newPw {
                // show error
                print("New password cannot be the same as current.")
                displayMessage(userMessage: "New password cannot be the same as current.")
                return
            } else if oldPw != user?.password {
                // show error
                print("Password entered does not match current password.")
                displayMessage(userMessage: "Password entered does not match password in database.")
                return
            } else if newPw != confirmPw {
                // show error
                print("New password does not match confirmed password")
                displayMessage(userMessage: "New password does not match confirmed password.")
                return
            } else {
               
                userController?.updatePassword(withUser: user!, andPassword: confirmPw) { (error) in
                    if let error = error {
                        print("Error updating password in tapped: \(error)")
                        self.displayMessage(userMessage: error.localizedDescription)
                        return
                    }
                    
                    self.userController?.updatePasswordLocal(withUser: self.user!, andPassword: confirmPw)
                    
                    self.userController?.updateMoltinCustomerPassword(customerID: self.user!.moltinUID, password: confirmPw, completion: { (error) in
                        if let error = error {
                            print("Error updating password in moltin: \(error)")
                            return
                        }
                        print("Successfully updated moltin password!")
                    })
                    
        
                    print("Successfull updated password!")
                    self.successDisplayMessage(userMessage: "Successfully updated password!")
                    DispatchQueue.main.async {
                        self.oldPasswordTextField.text = ""
                        self.confirmPasswordTextField.text = ""
                        self.newPasswordTextField.text = ""
                    }
                
                }
                
                
            }
            
        }
        
    }
    
    
    
    // MARK: Order History Properties
    let orderController = OrderController()
    
    @IBOutlet weak var orderTableView: UITableView!
    // custom table view cell
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.orderIds.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = orderTableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! AccountOrderHistoryTableViewCell
        
        if user?.orderIds[0] == "None" {
            self.coverView.alpha = 1
            cell.orderDateLabel.text = "No orders!"
            return cell
        }
        
        let order = self.user?.orderIds[indexPath.row]
        
        cell.orderIDLabel.text = order
        cell.orderID = order
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        // TODO: Get order details with id and w/o customer token
       /* moltin.order(withCustomerToken: userController!.token).get(forID: order!) { (result) in
            switch result {
            case .success(let result):
                print("Success reaching order!")
                cell.orderDate = self.dateFormatter.string(from: result.meta.timestamps.createdAt)
                cell.orderDateLabel.text = cell.orderDate
                cell.orderShippingStatus = "Shipping Status: \(result.shipping)"
                cell.orderContentsLabel.text = result.shipping
                cell.orderPaymentStatus = "Payment Status: \(result.payment)"
                cell.orderShippingAddress = ("Shipping Address: \(result.shippingAddress.line1) \(result.shippingAddress.line2) \n\(result.shippingAddress.city), \(result.shippingAddress.postcode)")
                cell.orderPaymentTotal = "Purchase Total: \(result.meta.displayPrice.withTax.formatted)"
                //self.orderItems = result.relationships?.items!.d
                
                
            case .failure(let error):
                print("Error grabbing order data: \(error)")
            }
        }*/
        
        getMoltinOrderByID(orderID: order!) { (error) in
            if let error = error {
                print("Error getting moltin order by id: \(error)")
                return
            }
           /* cell.orderDateLabel.text = self.orderController.orderDate as String
            cell.orderContentsLabel.text = self.orderController.orderShippingStatus as String */
            
        }
        
        cell.orderDateLabel.text = orderDate
        cell.orderContentsLabel.text = orderShippingStatus
        
        return cell
    }
    
    var orderDate: String?
    var orderID: String?
    var orderShippingStatus: String?
    var orderPaymentStatus: String?
    var orderPaymentTotal: String?
    var orderShippingAddress: String?
    var orderItems: String?
    
    func getMoltinOrderByID(orderID: String, completion: @escaping (Error?) -> Void = {_ in }) {
        var token: String = ""
        
        struct moltinToken: Codable {
            var clientID: String
            var token: String
            var expires: Date
        }
        
        if let data = UserDefaults.standard.value(forKey: "Moltin.auth.credentials") as? Data {
            let credentials = try? JSONDecoder().decode(moltinToken.self, from: data)
            token = credentials?.token ?? ""
        }
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.moltin.com/v2/orders/:\(orderID)")! as URL,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        orderController.fetchOrder(by: request as URLRequest) { (error) in
            if let error = error {
                print("Error fetching orders: \(error)")
                completion(error)
                return
            }
            
            self.orderDate = self.orderController.orderDate as String
            self.orderShippingStatus = self.orderController.orderShippingStatus as String
            self.orderPaymentStatus = self.orderController.orderPaymentStatus as String
            self.orderShippingAddress = self.orderController.orderShippingAddress as String
            self.orderPaymentTotal = self.orderController.orderPaymentTotal as String
            
            print("Successfully fetched order by id!: \(self.orderController.orderDate)")
            
        }
        
    }
    
    
    // MARK: Invite Friends Properties
    
    // MARK: Display Message Method
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Please Try Again", message: userMessage, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                    print("Ok button tapped")
                    DispatchQueue.main.async
                        {
                            self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
    
    func successDisplayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Success!", message: userMessage, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                    print("Ok button tapped")
                    DispatchQueue.main.async
                        {
                            self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
}
