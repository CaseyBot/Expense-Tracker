//
//  IncomeViewController.swift
//  Expense Tracker
//
//  Created by student on 10/23/22.
//

import UIKit
import CoreData
class IncomeViewController: UIViewController  {
    
    var bills:[Income]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var totalExpenses: UILabel!
    
    @IBOutlet weak var incomeTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        incomeTable.delegate = self
        incomeTable.dataSource = self
        fetchBills()
        incomeTable.reloadData()
        // Do any additional setup after loading the view.
        
        
        //To Delete Everything in Expenses
        
        //for object in bills!{
           // context.delete(object)
       // }
        
        //do{
        //    try context.save()
       // }catch{}
        
    }
    
    func fetchBills(with request: NSFetchRequest<Income> = Income.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            bills = try context.fetch(request)
            DispatchQueue.main.async{
                self.incomeTable.reloadData()
            }
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


extension IncomeViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.bills?.count ?? 0
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath)
        
            //cell.delegate = self
        let exp = cell.viewWithTag(7) as! UILabel
        let amount = cell.viewWithTag(9) as! UILabel
        let date = cell.viewWithTag(8) as! UILabel
        
        let expense = self.bills![indexPath.row]
        exp.text = expense.title
        amount.text = "\(expense.amount)"
        date.text = "\(expense.date!.formatted(date: .abbreviated, time: .omitted))"
            return cell
        }

    
    
}
