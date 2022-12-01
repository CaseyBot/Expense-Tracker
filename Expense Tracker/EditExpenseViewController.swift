//
//  EditExpenseViewController.swift
//  Expense Tracker
//
//  Created by student on 10/24/22.
//

import UIKit
import CoreData

//MARK: Create the objects from expense and context, create the variables to insert into the core data, transfer over all of the textfields from the main view

class EditExpenseViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedBill = Expense()
    var budget:[Budget]?
    var title2 = ""
    var amount2 = 0.00
    var type2 = ""
    var date2 = Date()
    var validationResult =  true
    @IBOutlet weak var title1: UITextField!
    @IBOutlet weak var amount1: UITextField!
    @IBOutlet weak var type1: UITextField!
    @IBOutlet weak var date1: UIDatePicker!
    
    //MARK: Transfer function from the editChanges button that is clicked
    
    @IBAction func editChanges(_ sender: Any) {
        if (title1.text?.isEmpty)! || (type1.text?.isEmpty)! || (amount1.text?.isEmpty)!{
            displayAlert()
        }
        if validateString(name: title1.text!)==false || validateString(name: type1.text!)==false || validatePrice(price: String(amount1.text!))==false {
            self.validationResult = false
        }
        if self.validationResult == true{
        changeMade()
        }
        else{
            showAlert()
        }
        self.validationResult =  true
        print("here")
        
    }
    
    //MARK: In the override viewDidLoad show the information from the core data for the row selected and change if the user decides to.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title1.text = selectedBill.title
        amount1.text = "\(selectedBill.amount)"
        type1.text = selectedBill.type
        date1.date = selectedBill.date!
        fetchBudget()
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
    
    //MARK: Validate input amount
    
    func validatePrice(price:String)->Bool{
        let priceRegex = #"(\-?\d+\.?\d{0,2})"#
        let result = price.range(
            of: priceRegex,
            options: .regularExpression
        )
        let validate = (result != nil)
        return validate
    }
    
    //MARK: Fetch the budget data from Core Data
    
    func fetchBudget(with request: NSFetchRequest<Budget> = Budget.fetchRequest()){
        do{
            budget = try context.fetch(request)
        }catch{
            print(error)
        }
        
    }
    
    //MARK: Get the text from the labels, request the expense object, search by title then take the first result and change the title, amount, type, and date as to what the user wants. Then saves the context and creates an alert. Send back to the expense controller
    
    func changeMade(){
        title2 = title1.text!
        amount2 = Double(amount1.text!)!
        type2 = type1.text!
        date2 = date1.date
        for b in budget!{
            if b.type == selectedBill.type{
                var bill = b
                var fetchrequest: NSFetchRequest<Budget> = Budget.fetchRequest()
                fetchrequest.predicate = NSPredicate(format: "type = %@",b.type!)
                let results = try? context.fetch(fetchrequest)
                if results?.count == 0{
                    bill = Budget(context: context)
                }else{
                    bill = (results?.first)!
                }
                if (bill.amount + selectedBill.amount) > bill.budget{
                    bill.amount = bill.budget
                }
                else{
                bill.amount = bill.amount + selectedBill.amount
                }
                do{
                try context.save()
                }catch{}
            }
            }
        
        var bill = selectedBill
        var fetchrequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "title = %@",selectedBill.title!)
        let results = try? context.fetch(fetchrequest)
        if results?.count == 0{
            bill = Expense(context: context)
        }else{
            bill = (results?.first)!
        }
        
        bill.title = title2
        bill.amount = amount2
        bill.type = type2
        bill.date = date2
        for b in budget!{
            if b.type == type2{
                var bill = b
                var fetchrequest: NSFetchRequest<Budget> = Budget.fetchRequest()
                fetchrequest.predicate = NSPredicate(format: "type = %@",b.type!)
                let results = try? context.fetch(fetchrequest)
                if results?.count == 0{
                    bill = Budget(context: context)
                }else{
                    bill = (results?.first)!
                }
                bill.amount = bill.amount - amount2
                do{
                try context.save()
                }catch{}
            }
        }

        do{
        try context.save()
        }catch{}
        createAlert(title:"Edited Expense",msg:"Your expense has been successfully editted!")

        

    }
    
    //MARK: Create the alert for done and dismiss the the alert when it is clicked
    
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{ (action: UIAlertAction!) in
            _=self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion:nil)}
    
    //MARK: Alert for invalid input
    
    func displayAlert(){
        let missingInformationAlert = UIAlertController(title: "Missing Information!",
                                                        message: "Make sure all the fields are filled",
                                                        preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        missingInformationAlert.addAction(cancelAction)
        self.present(missingInformationAlert, animated: true, completion: nil)
    }
    
    //MARK: Alert for empty input
    
    func showAlert(){
        let alert = UIAlertController(title:"invalid input!", message:"Make sure your input is correct",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",style:.cancel))
        present(alert, animated:true)
    }
}
