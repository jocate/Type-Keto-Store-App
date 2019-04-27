//
//  OrderHistoryDetailViewController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 4/24/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit

class OrderHistoryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = shippingStatusLabel.text
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
    
    var user: User?
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var orderIDLabel: UILabel!
    
    @IBOutlet weak var paymentStatusLabel: UILabel!
    
    @IBOutlet weak var shippingStatusLabel: UILabel!
    
    @IBOutlet weak var shippingAddressLabel: UILabel!
    
    @IBOutlet weak var paymentAmountLabel: UILabel!
    
    @IBOutlet weak var itemsLabel: UILabel!
    
    
    
    

}
