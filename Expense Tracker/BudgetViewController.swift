//
//  BudgetViewController.swift
//  Expense Tracker
//
//  Created by student on 10/26/22.
//

import UIKit
import CoreData
class BudgetViewController: UIViewController {
    @IBOutlet weak var budgetTable: UITableView!
    var bills:[Budget]?
    var selectedBill = Budget()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        budgetTable.delegate = self
        budgetTable.dataSource = self
        fetchBills()
        budgetTable.reloadData()

        // Do any additional setup after loading the view.
    }
    func reloadData(){
        fetchBills()
        DispatchQueue.main.async(execute:{self.budgetTable.reloadData()})
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "budgetToEdit"{
            let detailed_view = segue.destination as! EditBudgetController
            detailed_view.selectedBill = selectedBill
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadData()
        self.budgetTable.reloadData()
    }

    func fetchBills(with request: NSFetchRequest<Budget> = Budget.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            
            bills = try context.fetch(request)
            DispatchQueue.main.async{
                self.budgetTable.reloadData()
            }
        }catch{
            print(error)
        }
    }
}
    extension BudgetViewController: UITableViewDelegate, UITableViewDataSource{

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return bills!.count
         }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "budgetcell", for: indexPath)
            let exp = cell.viewWithTag(9) as! UILabel
            let amount = cell.viewWithTag(10) as! UILabel
            
            let expense = self.bills![indexPath.row]
            exp.text = expense.type
            amount.text = "\(expense.amount)"
                return cell
        }


         func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
             var expense = self.bills![indexPath.row]


            if editingStyle == UITableViewCell.EditingStyle.delete{
                budgetTable.beginUpdates()

                context.delete(expense)

                //expenseTable.reloadData()
                do{
                    try context.save()
    //                fetchBills()
                    
                    
                }catch {
                    print("Error While deleting")
                }
                budgetTable.endUpdates()
                //tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                self.viewDidLoad()

            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            selectedBill = bills![indexPath.row]
            self.performSegue(withIdentifier: "budgetToEdit", sender: self)
            
        }
    }
