//
//  EditBudgetController.swift
//  Expense Tracker
//
//  Created by student on 10/26/22.
//

import UIKit
import CoreData
//Create the context variables and the budget entities and title and amount variables from the main budget edit controller
class EditBudgetController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedBill = Budget()
    var budget:[Budget]?
    var expense:[Expense]?
    var title2 = ""
    var amount2 = 0.00
    var validationResult = true
    @IBOutlet weak var title1: UITextField!
    
    @IBOutlet weak var amount1: UITextField!
    //Edit button to trigget the changeMade() event and show the core data information in the viewDidLoad function within the dit budget controller in main
    @IBAction func edit(_ sender: Any) {
        if (title1.text?.isEmpty)! || (amount1.text?.isEmpty)!{
            displayAlert()
        }
        if validateString(name: title1.text!)==false || validatePrice(price: String(amount1.text!))==false {
            self.validationResult = false
        }
        if self.validationResult == true{
        changeMade()
        }
        else{
            showAlert()
        }
        self.validationResult =  true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title1.text = selectedBill.type
        amount1.text = "\(selectedBill.budget)"
        
        // Do any additional setup after loading the view.
    }
    //fetch the budget entity by searching through the type, use the first return object, change the type and amount then save this onto the db. Then create an alert and direct back to the budget controller
    func changeMade(){
        title2 = title1.text!
        amount2 = Double(amount1.text!)!
        var bill = selectedBill
        var fetchrequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "type = %@",selectedBill.type!)
        let results = try? context.fetch(fetchrequest)
        if results?.count == 0{
            bill = Budget(context: context)
        }else{
            bill = (results?.first)!
        }
        
        bill.type = title2
        bill.budget = amount2
        do{
            try context.save()
        }catch{}
        
        fetchBudget()
        fetchExpense()
        
        for b in budget!{
            if b.type == title2{
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
                bill.amount = bill.budget
                bill.amount = bill.amount - totalExpense
                do{
                    try context.save()
                }catch{}
            }
        }
        
        createAlert(title:"Edited Budget",msg:"Your budget has been successfully editted!")
        
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
    
    func fetchBudget(with request: NSFetchRequest<Budget> = Budget.fetchRequest()){
        //Fetch the data from Core Data to display in the tableview
        //context.
        do{
            budget = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    
    func fetchExpense(with request: NSFetchRequest<Expense> = Expense.fetchRequest()){
        //Fetch the data from Core Data to display in the tableview
        //context.
        do{
            expense = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    
    //Create alert with done button and return back to the budget controller
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{ (action: UIAlertAction!) in
            _=self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion:nil)}
    
    func displayAlert(){
        let missingInformationAlert = UIAlertController(title: "Missing Information!",
                                                        message: "Make sure all the fields are filled",
                                                        preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        missingInformationAlert.addAction(cancelAction)
        self.present(missingInformationAlert, animated: true, completion: nil)
    }
    
    func showAlert(){
        let alert = UIAlertController(title:"invalid input!", message:"Make sure your input is correct",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",style:.cancel))
        present(alert, animated:true)
    }
}
