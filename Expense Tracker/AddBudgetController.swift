//
//  AddBudgetController.swift
//  Expense Tracker
//
//  Created by student on 10/26/22.
//

import UIKit
import CoreData
// transfer current variables from the main view
class AddBudgetController: UIViewController {
    
    var bills:[Budget] = []
    var expense:[Expense]?
    @IBOutlet weak var title1: UITextField!
    @IBOutlet weak var amount1: UITextField!
    var validationResult = true
    //add function button that saves the new budget entity and append it to the expense object then create the alert for the budget that are added then return to the prior controller
    @IBAction func add(_ sender: Any) {
        if (title1.text?.isEmpty)! || (amount1.text?.isEmpty)!{
            displayAlert()
        }
        if validateString(name: title1.text!)==false || validatePrice(price:String(amount1.text!))==false {
            self.validationResult = false
        }
        
        if self.validationResult == true{
            let newExpense = Budget(context: self.context)
            newExpense.type = title1.text!
            newExpense.budget = Double(amount1.text!) ?? 0.0
            newExpense.amount = Double(amount1.text!) ?? 0.0
            self.bills.append(newExpense)
            saveBills()
            
            fetchExpense()
            for b in bills{
                if b.type == newExpense.type{
                    var totalExpense = Double(0.0)
                    for e in expense!{
                        if e.type == b.type{
                            totalExpense = totalExpense + e.amount
                        }
                    }
                    var bill = b
                    var fetchrequest: NSFetchRequest<Budget> = Budget.fetchRequest()
                    fetchrequest.predicate = NSPredicate(format: "type = %@",b.type!)
                    let results = try? context.fetch(fetchrequest)
                    if results?.count == 0{
                        bill = Budget(context: context)
                    }else{
                        bill = (results?.first)!
                    }
                    bill.amount = bill.amount - totalExpense
                    do{
                        try context.save()
                    }catch{}
                }
            }
            
            createAlert(title:"Added Budget",msg:"Your budget has been successfully added!")
        }
        
        else{
            showAlert()
        }
        
        self.validationResult = true
    }
    //Create the budget entity and context then viewDidLoad and fetch bills function
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBills()
        fetchExpense()
        print(bills)
        // Do any additional setup after loading the view.
    }
    //Save the context and fetch the budget entities and save to the core data
    func saveBills(){
        do {
            try context.save()
            
        } catch {
            print("Error saving context \(error)")
        }
        self.fetchBills()
        
    }
    
    func validateString(name:String)->Bool{
        let nameRegex = #"^[A-Za-z _][A-Za-z0-9 _]*$"#
        let result = name.range(
            of: nameRegex,
            options: .regularExpression
        )
        let validate = (result != nil)
        return validate
    }
    
    func validatePrice(price:String)->Bool{
        let priceRegex = #"(\-?\d+\.?\d{0,2})"#
        let result = price.range(
            of: priceRegex,
            options: .regularExpression
        )
        let validate = (result != nil)
        return validate
    }
    
    func fetchBills(with request: NSFetchRequest<Budget> = Budget.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            bills = try context.fetch(request)
        }catch{
            print(error)
        }
        
    }
    
    func fetchExpense(with request: NSFetchRequest<Expense> = Expense.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            expense = try context.fetch(request)
            
        }catch{
            print(error)
        }
        
    }
    //Create alert with done button and navigate back to the budget view controller in main
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{ (action: UIAlertAction!) in
            _=self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion:nil)}
    
    func showAlert(){
        let alert = UIAlertController(title:"invalid input!", message:"Make sure your input is correct",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",style:.cancel))
        present(alert, animated:true)
    }
    
    func displayAlert(){
        
        let missingInformationAlert = UIAlertController(title: "Missing Information!",
                                                        message: "Make sure all the fields are filled",
                                                        preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        missingInformationAlert.addAction(cancelAction)
        self.present(missingInformationAlert, animated: true, completion: nil)
    }
    
}
