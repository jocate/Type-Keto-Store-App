//
//  LearnDetailViewController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 4/24/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit

class LearnDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Typo Grotesk Thin", size: 17)!], for: UIControl.State.normal)
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        topicTitleLabel.text = topic?.title
        topicDetailLabel.text = topic?.description
        
    }
    
    var topic: Topic? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    @IBOutlet weak var topicTitleLabel: UILabel!
    @IBOutlet weak var topicDetailLabel: UILabel!
    
    

}
