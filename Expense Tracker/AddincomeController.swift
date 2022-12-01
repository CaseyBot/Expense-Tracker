//
//  AddincomeController.swift
//  Expense Tracker
//
//  Created by Sneha Seenuvasavarathan on 10/22/22.
//

import UIKit
import CoreData

class AddincomeController: UIViewController {
    
    //MARK: Add all of the income inputs and add the objects for expenses and summary entities and context
    @IBOutlet weak var incomeTitle: UITextField!
    @IBOutlet weak var incomeAmount: UITextField!
    @IBOutlet weak var incomeDate: UIDatePicker!
    
    var bills:[Income] = []
    var validationResult = true
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBills()
    }
    
    //MARK: Add Income Button for new expense for the expense entity and also add it to the summary entity. Create the alert after adding
    @IBAction func addIncomeButton(_ sender: Any) {
        if (incomeTitle.text?.isEmpty)! || (incomeAmount.text?.isEmpty)!{
            displayAlert()
        }
        if validateString(name: incomeTitle.text!)==false || validatePrice(price: String(incomeAmount.text!))==false {
            self.validationResult = false
        }
        
        if self.validationResult == true{
            let newIncome = Income(context: self.context)
            newIncome.title = incomeTitle.text!
            newIncome.amount = Double(incomeAmount.text!) ?? 0.0
            newIncome.date = incomeDate.date
            self.bills.append(newIncome)
            saveBills()
            
            createAlert(title:"Added Income",msg:"Your income has been successfully added!")
        }
        else{
            showAlert()
        }
        
        self.validationResult = true
        
    }
    
    //MARK: Save bills  into context and fetch the income object
    
    func saveBills(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    
    //MARK: Fetch Income Records
    
    func fetchBills(with request: NSFetchRequest<Income> = Income.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            bills = try context.fetch(request)
        }catch{
            print(error)
        }
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
    
    //MARK: Create alert with Done button and send back to income view controller
    
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{ (action: UIAlertAction!) in
            _=self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion:nil)}
    
    //MARK: Show alert when invalid input is entered
    
    func showAlert(){
        let alert = UIAlertController(title:"Invalid Input!", message:"Make sure your input is correct",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",style:.cancel))
        present(alert, animated:true)
    }
    
    //MARK: Show alert when input fileds are empty
    
    func displayAlert(){
        
        let missingInformationAlert = UIAlertController(title: "Missing Information!",
                                                        message: "Make sure all the fields are filled",
                                                        preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        missingInformationAlert.addAction(cancelAction)
        self.present(missingInformationAlert, animated: true, completion: nil)
        
        
    }
    
}
