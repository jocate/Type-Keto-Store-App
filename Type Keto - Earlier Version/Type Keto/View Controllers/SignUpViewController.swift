//
//  SignUpViewController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/18/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Typo Grotesk", size: 17)!], for: UIControl.State.normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromSignUpToHome" {
            let destinationVC = segue.destination as! HomePageViewController
            
            let user = userController.currentUser
            
            destinationVC.user = user
            destinationVC.userController = userController
        }
    }
    
    
    // segue: FromSignUpToHome
    
    let userController = UserController()
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text, let fullName = fullNameTextField.text {
            
            //Create Activity Indicator
            let myActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 100,y: 200, width: 250, height: 250))
            myActivityIndicator.style = (UIActivityIndicatorView.Style.gray)
            
            // Position Activity Indicator in the center of the main view
            myActivityIndicator.center = self.view.center
            
            // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
            myActivityIndicator.hidesWhenStopped = false
            
            // Start Activity Indicator
            myActivityIndicator.startAnimating()
            
            DispatchQueue.main.async {
                self.view.addSubview(myActivityIndicator)
            }
            
            userController.createUserAccount(withEmail: email, andPassword: password, andName: fullName) { (error) in
                
                if let error = error {
                    NSLog("Error creating user: \(error)")
                    self.displayMessage(userMessage: "\(error.localizedDescription)")
                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                    return
                }
                
                self.userController.createMoltinCustomer(userName: fullName, userEmail: email, password: password) { (error) in
                    if let error = error {
                        print("Error creating a moltin customer: \(error)")
                        return
                    }
                    //self.token = self.userController.token
                    //self.clientID = self.userController.clientID
                    print("User muid in VC: \(self.userController.currentUser?.moltinUID)")
                    // print("Client ID in sign up VC: \(self.clientID)")
                    
                    self.userController.generateMoltinToken(email: email, password: password, completion: { (error) in
                        if let error = error {
                            print("Error generating a moltin token: \(error)")
                            return
                        }
                    })
                }
                
                DispatchQueue.main.async {
                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                    self.performSegue(withIdentifier: "FromSignUpToHome", sender: self)
                }
            }
            
           
            
        }
    }
    
    var token: String?
    
    
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        fullNameTextField.resignFirstResponder()
    }
    
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
    
}
