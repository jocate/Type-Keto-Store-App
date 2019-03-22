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
            
            userController.createUserAccount(withEmail: email, andPassword: password, andName: fullName) { (error) in
                if let error = error {
                    NSLog("Error creating user: \(error)")
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "FromSignUpToHome", sender: self)
                }
            }
        }
    }
    
    
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        fullNameTextField.resignFirstResponder()
    }
    
}
