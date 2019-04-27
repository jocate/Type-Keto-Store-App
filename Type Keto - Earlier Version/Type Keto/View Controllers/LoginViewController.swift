//
//  LoginViewController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/18/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromLogintoHome" {
            let destinationVC = segue.destination as! HomePageViewController
            
            let user = userController.currentUser
            print("User from Login Segue: \(user?.emailAddress)")
            destinationVC.user = user
            destinationVC.userController = userController
        }
    }
    
    
    // segue: FromLoginToHome
    
    let userController = UserController()
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            NSLog("Fields are empty")
            return
        }
        
        //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 100,y: 200, width: 200, height: 200))
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
        
        userController.login(withEmail: email, andPassword: password) { (error) in
            
            // TODO: Update UI for error case
            if let error = error {
                NSLog("Error logging in: \(error.localizedDescription)")
                self.displayMessage(userMessage: "\(error.localizedDescription)")
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                return
            }
            
            self.userController.generateMoltinToken(email: email, password: password) { (error) in
                if let error = error {
                    print("Error generating moltin token: \(error)")
                    return
                }
                
            }
            
            DispatchQueue.main.async {
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                self.performSegue(withIdentifier: "FromLogintoHome", sender: self)
            }
        }
        
        
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func continueAsGuestTapped(_ sender: UIButton) {
        // TODO: Guest Entry
        //Create Activity Indicator
        
        let myActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 100,y: 200, width: 150, height: 150))
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
        // login under guest account
        userController.login(withEmail: "guest@guest.com", andPassword: "guest1234") { (error) in
            
            
            if let error = error {
                NSLog("Error logging in: \(error)")
                self.displayMessage(userMessage: "\(error.localizedDescription)")
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                return
            }
            NotificationCenter.default.post(name: .guestUI, object: nil)
            
            self.userController.generateMoltinToken(email: "guest@guest.com", password: "guest1234") { (error) in
                if let error = error {
                    print("Error generating moltin token: \(error)")
                    return
                }
                
            }
            DispatchQueue.main.async {
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                self.performSegue(withIdentifier: "FromLogintoHome", sender: self)
            }
        }
        
        // send notification to update the check out UI to include an 'email address' field
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
