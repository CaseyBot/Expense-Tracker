//
//  ExpenseViewController.swift
//  Expense Tracker
//
//  Created by Sneha Seenuvasavarathan on 10/23/22.
//

import UIKit
import CoreData
class ExpenseViewController: UIViewController  {
    
    var bills:[Expense] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var totalExpenses: UILabel!
    @IBOutlet weak var expenseTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBills()
        expenseTable.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func fetchBills(with request: NSFetchRequest<Expense> = Expense.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            bills = try context.fetch(request)
            print(bills[7].title)
        }catch{
            print(error)
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

}


extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as! ExpenseTableViewCell
                
//        cell.textLabel?.text = bills[indexPath.row].title
//        cell.title?.text = bills[indexPath.row].title
        cell.title.text = bills[indexPath.row].title
        cell.amount.text = "\(bills[indexPath.row].amount)"
        cell.date.text = "\(bills[indexPath.row].date)"
    
//        cell.accessoryType = bills[indexPath.row].done ? .checkmark : .none
        

        return cell
    }
    
    
}
