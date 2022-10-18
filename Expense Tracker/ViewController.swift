//
//  ViewController.swift
//  Expense Tracker
//
//  Created by student on 10/4/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.delegate = self
        
        return cell
    }
    
    @IBOutlet weak var homeView: UITableView!
    
    override func viewDidLoad() {
        ///
        super.viewDidLoad()
        
        homeView.delegate = self
        homeView.dataSource = self
        
        // Do any additional setup after loading the view.
    }


}

