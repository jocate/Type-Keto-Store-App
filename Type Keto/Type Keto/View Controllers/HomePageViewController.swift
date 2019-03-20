//
//  HomePageViewController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 3/18/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let productController = ProductController()

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Within the collection view: \(productController.displayProducts.count)")
        return productController.displayProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        
        let product = productController.displayProducts[indexPath.item]
        cell.product = product
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productController.fetchProducts { (products, error) in
            if let error = error {
                NSLog("Error fetching products: \(error)")
            }
            print(self.productController.displayProducts.count)
            DispatchQueue.main.async {
                self.productCollectionView.reloadData()
            }
            
        }
        updateViews()
       // setUpNavBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.productCollectionView.reloadData()
    }
    
    func setUpNavBar() {
        
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
        navigationController?.navigationBar.setBackgroundImage(blueNavBar, for: .default)
       
    }
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var footerView: UIView!
    var userController: UserController?
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    
    @IBAction func cartTapped(_ sender: UIButton) {
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
