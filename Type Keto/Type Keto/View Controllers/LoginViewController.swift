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
        
        userController.login(withEmail: email, andPassword: password) { (error) in
            // TODO: Update UI for error case
            if let error = error {
                NSLog("Error logging in: \(error)")
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "FromLogintoHome", sender: self)
            }
        }
        
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func continueAsGuestTapped(_ sender: UIButton) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
}
