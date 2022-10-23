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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBills()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func addExpenseButton(_ sender: Any) {
        let newExpense = Expense(context: self.context)
        newExpense.title = expenseTitle.text!
        newExpense.amount = Double(expenseAmount.text!) ?? 0.0
        newExpense.type = expenseType.text!
        newExpense.date = expenseDate.date
       
        self.bills.append(newExpense)
        saveBills()
    }
    
    func saveBills(){
        do {
                    try context.save()
                } catch {
                    print("Error saving context \(error)")
                }
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
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
