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
        
        cell.layer.borderColor = UIColor.yellow.cgColor
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 8
       // cell.layer.backgroundColor = UIColor.lightGray.cgColor
        
        if let product = self.products?[indexPath.item] {
            
            cell.productNameLabel.text = product.name
            cell.productPriceLabel.text = product.meta.displayPrice!.withTax.formatted
            //print("1. \(product.meta.displayPrice?.withTax.formatted)")
            
            cell.productSizeLabel.text = product.description
           // cell.productImageView.image = UIImage(data: product.relationships?.mainImage?.data)
            
            self.moltin.product.include([.mainImage]).get(forID: product.id, completionHandler: { (result: Result<Product>) in
                switch result {
                case .success(let product):
                    DispatchQueue.main.async {
                        cell.productImageView.load(urlString: product.mainImage!.link["href"], productName: product.name)
                        //print("Image : \(cell.productImageView.load(urlString: product.mainImage!.link["href"]))")
                        //cell.backgroundColor = product.backgroundColor
                    }
                default: break
                }
            })
            cell.product = product
            
           // return cell
        }
        
        return cell
    }
    let rewardButton = UIButton(type: .system)
    let learnButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Typo Grotesk", size: 17)!], for: UIControl.State.normal)
        
        rewardButton.addTarget(self, action: #selector(rewardButtonTapped), for: .touchUpInside)
        
        learnButton.addTarget(self, action: #selector(learnButtonTapped), for: .touchUpInside)
        
        setUpNavBar()
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
  
    @IBAction func learnButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ToLearn", sender: self)
        }
    }
    
    @IBAction func rewardButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ToRewards", sender: self)
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
            destinationVC.userController = userController
            
           // destinationVC.productController = productController
        } else if segue.identifier == "ToAccount" {
            let destinationVC = segue.destination as! AccountViewController
            
            destinationVC.user = user
            destinationVC.userController = userController
            
        } else if segue.identifier == "ToLearn" {
            let destinationVC = segue.destination as! LearnViewController
            
            destinationVC.user = user
            destinationVC.userController = userController
            
        } else if segue.identifier == "ToRewards" {
            let destinationVC = segue.destination as! RewardsViewController
            
            destinationVC.user = user
            destinationVC.userController = userController
            
        }
        
    }
    
    func setUpNavBar() {
        
        let blueNavBar = UIImage(named: "blueNavBar")
        //navigationController?.navigationBar.barTintColor = .blue
        navigationController?.navigationBar.setBackgroundImage(blueNavBar, for: .default)
        
        let shopIcon = UIImage(named: "shopjpg")
        let shopButton = UIButton(type: .system)
       // titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        shopButton.setImage(shopIcon?.withRenderingMode(.alwaysOriginal), for: .normal)
        shopButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationItem.titleView = shopButton
        shopButton.contentMode = .scaleAspectFill
        
        let rewardIcon = UIImage(named: "rewardsjpg")
        
        rewardButton.setImage(rewardIcon?.withRenderingMode(.alwaysOriginal), for: .normal)
        rewardButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: rewardButton)
        rewardButton.contentMode = .scaleAspectFill
        
        let learnIcon = UIImage(named: "learnjpg")
        
        learnButton.setImage(learnIcon?.withRenderingMode(.alwaysOriginal), for: .normal)
        learnButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: learnButton)
        learnButton.contentMode = .scaleAspectFill
        
        /* to add another to the right, add the same initializers from above
         
         navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: learnButton), UIBarButtonItem(customView: anotherButton)] */
       
        
    }
    
    
}

