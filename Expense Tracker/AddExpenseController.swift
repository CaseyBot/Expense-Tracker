//
//  AddExpenseController.swift
//  Expense Tracker
//
//  Created by Sneha Seenuvasavarathan on 10/22/22.
//

import UIKit
import CoreData
import Foundation


class AddExpenseController: UIViewController{
    
    
    @IBOutlet weak var expenseTitle: UITextField!
    
    @IBOutlet weak var expenseAmount: UITextField!
    
    @IBOutlet weak var expenseDate: UIDatePicker!
    
    @IBOutlet weak var expenseType: UITextField!
   
    //MARK: Created  object array to later change for expense and for overall summary, and the context
    
    var bills:[Expense] = []
    var summary:[Summary] = []
    var budget:[Budget]?
    var validationResult = true
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBills()
        fetchBudget()

    }
    
    //MARK: Button to add expense and save the new expense, then save it to the summary entity to show in the home view
    
    @IBAction func addExpenseButton(_ sender: Any) {
        if (expenseTitle.text?.isEmpty)! || (expenseAmount.text?.isEmpty)! || (expenseType.text?.isEmpty)!{
            displayAlert()
        }
        if validateString(name: expenseTitle.text!)==false || validateString(name: expenseType.text!)==false || validatePrice(price: String(expenseAmount.text!))==false {
            self.validationResult = false
        }
       
        if self.validationResult == true{
            let newExpense = Expense(context: self.context)
            newExpense.title = expenseTitle.text!
            newExpense.amount = Double(expenseAmount.text!) ?? 0.0
            newExpense.type = expenseType.text!
            newExpense.date = expenseDate.date
            self.bills.append(newExpense)
            saveBills()
            
            
            for b in budget!{
                if b.type == newExpense.type{
                    var bill = b
                    var fetchrequest: NSFetchRequest<Budget> = Budget.fetchRequest()
                    fetchrequest.predicate = NSPredicate(format: "type = %@",b.type!)
                    let results = try? context.fetch(fetchrequest)
                    if results?.count == 0{
                        bill = Budget(context: context)
                    }else{
                        bill = (results?.first)!
                    }
                    bill.amount = bill.amount - newExpense.amount
                    do{
                    try context.save()
                    }catch{}
                }
            }

            createAlert(title:"Added Expense",msg:"Your expense has been successfully added!")
            
        }
        else{
            showAlert()
        }
        self.validationResult = true

    }
    
    //MARK: Validate input text
    
    func validateString(name:String)->Bool{
        let nameRegex = #"^[A-Za-z _][A-Za-z0-9 _]*$"#
        let result = name.range(
            of: nameRegex,
            options: .regularExpression
        )
        let validate = (result != nil)
        return validate
    }
    
    //MARK: Validate input text
    
    func validatePrice(price:String)->Bool{
        let priceRegex = #"(\-?\d+\.?\d{0,2})"#
        let result = price.range(
            of: priceRegex,
            options: .regularExpression
        )
        let validate = (result != nil)
        return validate
    }
    
    //MARK: Save the context expense in the core data

    func saveBills(){
        do {
                    try context.save()
                
                } catch {
                    print("Error saving context \(error)")
                }
        self.fetchBills()
    }
    
    //MARK: Fetch the expense context
    
    func fetchBills(with request: NSFetchRequest<Expense> = Expense.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            bills = try context.fetch(request)
            
        }catch{
            print(error)
        }
        
    }
    
    //MARK: Save budget details to database
    
    func saveBudget(){
        do {
                    try context.save()
                
                } catch {
                    print("Error saving context \(error)")
                }
        self.fetchBudget()
        
    }
    
    //MARK: Fetch the expense context
    
    func fetchBudget(with request: NSFetchRequest<Budget> = Budget.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            budget = try context.fetch(request)
            
        }catch{
            print(error)
        }
        
    }

    //MARK: create an alert for adding expense  and navigate back to the expense view
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        //alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{_ in self.dismiss(animated: true, completion:nil)}))
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{ (action: UIAlertAction!) in
            _=self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion:nil)}

    //MARK: Alert for invalid input
    
    func showAlert(){
        let alert = UIAlertController(title:"invalid input!", message:"Make sure your input is correct",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",style:.cancel))
        present(alert, animated:true)
    }
    
    //MARK: Alert for empty input
    
    func displayAlert(){
        let missingInformationAlert = UIAlertController(title: "Missing Information!",
                                                        message: "Make sure all the fields are filled",
                                                        preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        missingInformationAlert.addAction(cancelAction)
        self.present(missingInformationAlert, animated: true, completion: nil)
    }
}
