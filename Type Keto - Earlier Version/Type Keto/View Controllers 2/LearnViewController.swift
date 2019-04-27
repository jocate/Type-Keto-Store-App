//
//  LearnViewController.swift
//  Type Keto
//
//  Created by Lambda_School_Loaner_95 on 4/23/19.
//  Copyright © 2019 Type Keto LLC. All rights reserved.
//

import UIKit

class LearnViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        topics.append(netCarbTopic)
        topics.append(calcNetCarbTopic)
        
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Typo Grotesk", size: 17)!], for: UIControl.State.normal)
        // Do any additional setup after loading the view.
    }
    
    var user: User?
    var userController: UserController?
    @IBOutlet weak var learnTableView: UITableView!
    
    let netCarbTopic = Topic(title: "What is a net carb?", description: " *disclaimer: There is no official definition of a net carb \n\nNet carbs refer to carbs that are absorbed by the body and used for energy (like sugars and starches), or otherwise known as carbs that affect blood sugar \n\nFiber and some (not all) sugar alcohols do not count as net carbs because our bodies do not utilize them and can not break them down")
    let calcNetCarbTopic = Topic(title: "How to calculate net carbs", description: "In order to calculate net carbs: subtract a product's fiber and sugar alcohols (ex erythritol and xylitol) from the total amount of carbs in the product \n\nTotal Carbs - fiber - sugar alcohols \n\n (again, not all sugar alcohols qualify)")
    
    var topics: [Topic] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = learnTableView.dequeueReusableCell(withIdentifier: "LearnCell", for: indexPath)
        cell.layer.borderColor = UIColor.blue.cgColor
        cell.layer.cornerRadius = 8
        
        let topic = self.topics[indexPath.row]
        cell.textLabel?.text = topic.title
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LearnDetail" {
            let destinationVC = segue.destination as! LearnDetailViewController
            if let indexPath = learnTableView.indexPathForSelectedRow {
                destinationVC.topic = self.topics[indexPath.row]
            }
            
        }
    }
    
    

}
