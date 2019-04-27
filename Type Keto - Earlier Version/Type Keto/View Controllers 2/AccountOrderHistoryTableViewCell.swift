//
//  AccountOrderHistoryTableViewCell.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 4/23/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit

class AccountOrderHistoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var orderDate: String?
    var orderID: String?
    var orderShippingStatus: String?
    var orderPaymentStatus: String?
    var orderPaymentTotal: String?
    var orderShippingAddress: String?
    var orderItems: String?
    
    @IBOutlet weak var orderDateLabel: UILabel!
    
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var orderContentsLabel: UILabel!
    

}
