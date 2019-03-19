//
//  HomePageViewController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/18/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        // Do any additional setup after loading the view.
    }
   
    var userController: UserController?
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        if let user = user {
            welcomeLabel.text = "Welcome \(user.fullName)!"
        } else {
            welcomeLabel.text = "Welcome Guest!"
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var welcomeLabel: UILabel!
    
}
