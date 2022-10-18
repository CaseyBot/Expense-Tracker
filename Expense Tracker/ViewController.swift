//
//  ViewController.swift
//  Expense Tracker
//
//  Created by student on 10/4/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var homeView: UITableView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchBills(){
        //Fetch the data from Core Data to displau in the tableview
        //context.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.delegate = self
        
        return cell
    }
    

    override func viewDidLoad() {
        ///
        super.viewDidLoad()
        
        homeView.delegate = self
        homeView.dataSource = self
        func fetchBills()
        // Do any additional setup after loading the view.
    }


}

