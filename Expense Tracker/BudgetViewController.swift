//
//  BudgetViewController.swift
//  Expense Tracker
//
//  Created by student on 10/26/22.
//

import UIKit
import CoreData
//create variables for the budget entities and context, then delegate the delgate and dataSource to self and reload the data
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
    //reloadData reloads the budgetTable
    func reloadData(){
        fetchBills()
        DispatchQueue.main.async(execute:{self.budgetTable.reloadData()})
    }
    
    //Prepare the segue for the budgetToEdit and send the selected budget item
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "budgetToEdit"{
            let detailed_view = segue.destination as! EditBudgetController
            detailed_view.selectedBill = selectedBill
            
        }
    }
    //Create the viewDidAppear load and reload the core data and table view
    override func viewDidAppear(_ animated: Bool) {
        reloadData()
        self.budgetTable.reloadData()
    }
    //Fetchthe budget context and reload the budgetTable then print if there is an error
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
    //extension to edit the tableView with the row count and the size to 100 then return the data
    extension BudgetViewController: UITableViewDelegate, UITableViewDataSource{

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return bills!.count
         }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
        //Change the labels in budgetcell  then show the core data in these labels in the cells
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "budgetcell", for: indexPath)
            let exp = cell.viewWithTag(9) as! UILabel
            let amount = cell.viewWithTag(10) as! UILabel
            
            let expense = self.bills![indexPath.row]
            exp.text = expense.type
            amount.text = "$\(expense.amount) left"
                return cell
        }

        //Delete function to delete the current row from the core data then print possible errors and reload the data
         func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
             var expense = self.bills![indexPath.row]


            if editingStyle == UITableViewCell.EditingStyle.delete{
                budgetTable.beginUpdates()

                context.delete(expense)

                do{
                    try context.save()
                }catch {
                    print("Error While deleting")
                }
                budgetTable.endUpdates()

                self.viewDidLoad()

            }
        }
        //Prepare the segue for row selected with budgetToEdit and send current row 
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            selectedBill = bills![indexPath.row]
            self.performSegue(withIdentifier: "budgetToEdit", sender: self)
            
        }
    }
