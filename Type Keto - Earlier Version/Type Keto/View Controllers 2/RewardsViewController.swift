//
//  RewardsViewController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 4/23/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit

class RewardsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Typo Grotesk", size: 17)!], for: UIControl.State.normal)
        updateViews()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateViews() {
        guard isViewLoaded else { return }
        if let userLocal = user {
            
            if userLocal.fullName == "Guest" {
                pointsLabel.text = "0"
                titleLabel.text = "Guests can't track rewards!"
            } else {
                if userLocal.rewardPoints == 0 {
                    titleLabel.text = "Make a purchase to earn rewards!"
                    pointsLabel.text = String(userLocal.rewardPoints)
                } else {
                    pointsLabel.text = String(userLocal.rewardPoints)
                    titleLabel.text = "Reward Points"
                }
                
            }
            
        }
        
    }
    
    var user: User? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    var userController: UserController?
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
}
