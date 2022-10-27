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
   
    //Created  object array to later change for expense and for overall summary, and the context
    
    var bills:[Expense] = []
    var summary:[Summary] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBills()
        fetchSummary()
    }
    //Button to add expense and save the new expense, then save it to the summary entity to show in the home view
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

    }
    //Save the context expense in the core data

    func saveBills(){
        do {
                    try context.save()
                
                } catch {
                    print("Error saving context \(error)")
                }
        self.fetchBills()
        
    }
    //Fetch the expense context
    func fetchBills(with request: NSFetchRequest<Expense> = Expense.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            bills = try context.fetch(request)
            
        }catch{
            print(error)
        }
        
    }
//Save into summary entity for the home view
    func saveSummary(){
        do {
                    try context.save()
                } catch {
                    print("Error saving context \(error)")
                }
        self.fetchSummary()
    }
  //fetch the summary request entity
    func fetchSummary(with request: NSFetchRequest<Summary> = Summary.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
 
        do{
            summary = try context.fetch(request)
        }catch{
            print(error)
        }
    }
//create an alert for adding expense  and navigate back to the expense view
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        //alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{_ in self.dismiss(animated: true, completion:nil)}))
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{ (action: UIAlertAction!) in
            _=self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion:nil)}


}
