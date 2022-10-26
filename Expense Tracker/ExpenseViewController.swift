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
    var selectedBill = Expense()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var totalExpenses: UILabel!
    @IBOutlet weak var expenseTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseTable.delegate = self
        expenseTable.dataSource = self
        fetchBills()
        expenseTable.reloadData()
        // Do any additional setup after loading the view.
        //To Delete Everything in Expenses
        
        //for object in bills!{
           // context.delete(object)
       // }
        
        //do{
        //    try context.save()
       // }catch{}
        
    }
    
    func reloadData(){
        fetchBills()
        DispatchQueue.main.async(execute:{self.expenseTable.reloadData()})
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ExpenseToEdit"{
            let detailed_view = segue.destination as! EditExpenseViewController
            detailed_view.selectedBill = selectedBill
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadData()
    }
    func fetchBills(with request: NSFetchRequest<Expense> = Expense.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            
            bills = try context.fetch(request)
            DispatchQueue.main.async{
                self.expenseTable.reloadData()
            }
        }catch{
            print(error)
        }
    }

}


extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bills.count
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath)
        let exp = cell.viewWithTag(4) as! UILabel
        let amount = cell.viewWithTag(6) as! UILabel
        let date = cell.viewWithTag(5) as! UILabel
        
        let expense = self.bills[indexPath.row]
        exp.text = expense.title
        amount.text = "\(expense.amount)"
        date.text = "\(expense.date?.formatted(date: .abbreviated, time: .omitted))"
            return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let expense = self.bills[indexPath.row]

        if editingStyle == UITableViewCell.EditingStyle.delete{
            expenseTable.beginUpdates()
            context.delete(expense)
//            bills.remove(at: indexPath.row)
            
            //expenseTable.reloadData()
            do{
                try context.save()
//                fetchBills()
                reloadData()
                expenseTable.reloadData()
                //self.expenseTable.deleteRows(at: [indexPath], with: .automatic)
                
            }catch {
                print("Error While deleting")
            }
            expenseTable.endUpdates()
            //tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        selectedBill = bills[indexPath.row]
        self.performSegue(withIdentifier: "ExpenseToEdit", sender: self)
    }
}
