//
//  ImageView+LoadImageURL.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 4/19/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit

var productImageCache: [String: Data] = [:]
extension UIImageView {
    
    func load(urlString string: String?, productName: String) {
        guard let imageUrl = string,
            let url = URL(string: imageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                productImageCache[productName] = data
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
    
    
  
}

