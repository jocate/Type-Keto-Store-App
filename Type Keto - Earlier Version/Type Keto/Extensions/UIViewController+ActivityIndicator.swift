//
//  UIViewController+ActivityIndicator.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 4/22/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async
            {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
        }
    }
    
}

