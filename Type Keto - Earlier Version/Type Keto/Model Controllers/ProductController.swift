//
//  ProductController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/19/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import Foundation

/*class ProductController {
    
    var cart: [Product] = []
    
    var displayProducts: [Product] = []
    
    let cartController = CartController()
    
    let baseURL = URL(string: "https://type-keto-store.firebaseio.com/")!
    
    func adminCreateProduct(withName name: String, andSize size: String, andFlavors numOfFlavors: Int, image: Data, price: Double) {
        let product = Product(name: name, size: size, numOfFlavors: numOfFlavors, image: image, price: price)
        
        putProductToServer(product: product)
       // products.append(product)
    }
    
    func adminUpdateProduct(){}
    
    func addProductToCart(withProduct product: Product, completion: @escaping (Error?) -> Void) {
        cart.append(product)
        
    }
    
    func customerEditProduct(withProduct product: Product, andQuantity quantity: Int) {
        guard let index = cart.index(of: product) else { return }
        cart[index].quantity = quantity
    }
    
    func deleteProductFromCart(withProduct product: Product, completion: @escaping (Error?) -> Void = {_ in }) {
        guard let index = self.cart.index(of: product) else { return }
        self.cart.remove(at: index)
    }
    
    func putProductToServer(product: Product, completion: @escaping (Error?) -> Void = {_ in }) {
        
        let identifier = product.productId ?? UUID().uuidString
        
        let urlPlusItem = baseURL.appendingPathComponent("products")
        let urlPlusId = urlPlusItem.appendingPathComponent(identifier)
        let urlPlusJSON = urlPlusId.appendingPathExtension("json")
        
        var request = URLRequest(url: urlPlusJSON)
        request.httpMethod = "PUT"
        
        do {
            let encoder = JSONEncoder()
            let productJSON = try encoder.encode(product)
            request.httpBody = productJSON
        } catch {
            NSLog("Error encoding error: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error putting product to the server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
        
    }
    
    func fetchProducts(completion: @escaping ([Product]?, Error?) -> Void) {
        let urlPlusItem = baseURL.appendingPathComponent("products")
        let urlPlusJSON = urlPlusItem.appendingPathExtension("json")
        
       // var request = URLRequest(url: urlPlusJSON)
        
        URLSession.shared.dataTask(with: urlPlusJSON) { (data, _, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError())
                return
            }
            
            do {
                let productDict = try JSONDecoder().decode([String: Product].self, from: data)
                let products = Array(productDict.values)
                
                self.displayProducts = products
                completion(products, nil)
            } catch {
                completion(nil, error)
                return
            }
        }.resume()
        
        
        
    }
    
}*/
