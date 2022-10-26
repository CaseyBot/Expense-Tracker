//
//  AddExpenseController.swift
//  Expense Tracker
//
//  Created by Sneha Seenuvasavarathan on 10/22/22.
//

import UIKit
import CoreData

class AddExpenseController: UIViewController {
    
    
    @IBOutlet weak var expenseTitle: UITextField!
    
    
    @IBOutlet weak var expenseAmount: UITextField!
    
    @IBOutlet weak var expenseDate: UIDatePicker!
    
    @IBOutlet weak var expenseType: UITextField!
    
    var bills:[Expense] = []
    var summary:[Summary] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBills()
        fetchSummary()
    }

    @IBAction func addExpenseButton(_ sender: Any) {
        let newExpense = Expense(context: self.context)
        newExpense.title = expenseTitle.text!
        newExpense.amount = Double(expenseAmount.text!) ?? 0.0
        newExpense.type = expenseType.text!
        newExpense.date = expenseDate.date
        self.bills.append(newExpense)
        saveBills()

        let newSummary = Summary(context: self.context)
        newSummary.title = expenseTitle.text!
        newSummary.amount = Double(expenseAmount.text!) ?? 0.0
        newSummary.type = "Expense"
        newSummary.date = expenseDate.date
        self.summary.append(newSummary)
        saveSummary()
        //self.performSegue(withIdentifier: "seg_expense_to_add", sender: self)

        createAlert(title:"Added Expense",msg:"Your expense has been successfully added!")

        _ = navigationController?.popToRootViewController(animated: true)


    }
    //override func viewDidDisappear(_ animated: Bool){
      //  let statTab = self.tabBarController?.children[1] as! ExpenseViewController
        //statTab.expenseTable.reloadData()

        
    //}

    func saveBills(){
        do {
                    try context.save()
                
                } catch {
                    print("Error saving context \(error)")
                }
        self.fetchBills()
        
    }
    
    func fetchBills(with request: NSFetchRequest<Expense> = Expense.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            bills = try context.fetch(request)
            
        }catch{
            print(error)
        }
        
    }

    func saveSummary(){
        do {
                    try context.save()
                } catch {
                    print("Error saving context \(error)")
                }
        self.fetchSummary()
    }
    
    func fetchSummary(with request: NSFetchRequest<Summary> = Summary.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            summary = try context.fetch(request)
        }catch{
            print(error)
        }
    }

    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{_ in self.dismiss(animated: true, completion:nil)}))
        self.present(alert, animated: true, completion:nil)}

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
