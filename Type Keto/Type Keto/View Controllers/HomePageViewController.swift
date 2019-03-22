//
//  HomePageViewController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/18/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit
import moltin

class HomePageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
  //  let productController = ProductController()
    
    let moltin: Moltin = Moltin(withClientID: "rxlE4z2FEDFv8YJdPN0GC9wzclQITMemsoathUB4Vt")
    
    var products: [Product]? = []
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // print("Within the collection view: \(productController.displayProducts.count)")
        return self.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        
        let product = self.products?[indexPath.item]
        cell.productNameLabel.text = product?.name
        cell.productPriceLabel.text = product?.meta.displayPrice?.withoutTax.formatted
        cell.productSizeLabel.text = product?.description
       // cell.productImageView.image = UIImage(data: product?.mainImage)
        
        cell.product = product
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* productController.fetchProducts { (products, error) in
            if let error = error {
                NSLog("Error fetching products: \(error)")
            }
            print(self.productController.displayProducts.count)
            DispatchQueue.main.async {
                self.productCollectionView.reloadData()
            }
            
        }
        updateViews()
        setUpNavBar()*/
        
        self.moltin.product.all { (result: Result<PaginatedResponse<[Product]>> ) in
            switch result {
            case .success(let response):
                self.products = response.data ?? []
                DispatchQueue.main.async {
                    self.productCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error getting products: \(error)")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // setUpNavBar()
        updateViews()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)
       // self.productCollectionView.reloadData()
    }
    
   
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var userController: UserController?
    
    var user: User? {
        didSet {
            updateViews()
            // updateCart()
        }
    }
   
    
    @IBAction func cartTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ToCart", sender: self)
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
    
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCart" {
            let destinationVC = segue.destination as! CartViewController
            
            print("User from home Segue: \(user?.emailAddress)")
           
            destinationVC.user = user
           // destinationVC.productController = productController
        }
        
    }
    
    /*func setUpNavBar() {
        
        let shopIcon = UIImage(named: "shopIcon")
        let titleImageView = UIImageView(image: shopIcon)
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        
        let rewardIcon = UIImage(named: "rewardsIcon")
        let rewardButton = UIButton(type: .system)
        rewardButton.setImage(rewardIcon?.withRenderingMode(.alwaysOriginal), for: .normal)
        rewardButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: rewardButton)
        
        let learnIcon = UIImage(named: "learnIcon")
        
        let learnButton = UIButton(type: .system)
        learnButton.setImage(learnIcon?.withRenderingMode(.alwaysOriginal), for: .normal)
        learnButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: learnButton)
        
        /* to add another to the right, add the same initializers from above
         
         navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: learnButton), UIBarButtonItem(customView: anotherButton)] */
        let blueNavBar = UIImage(named: "blueNavBar")
        navigationController?.navigationBar.barTintColor = .blue
       // navigationController?.navigationBar.setBackgroundImage(blueNavBar, for: .default)
        
    }*/
    
    
}

