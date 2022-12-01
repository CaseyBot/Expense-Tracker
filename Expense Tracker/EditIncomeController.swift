//
//  EditIncomeController.swift
//  Expense Tracker
//
//  Created by student on 10/24/22.
//

import UIKit
import CoreData

//MARK: create the object variables and variables for the title, amount, and data from the text fields

class EditIncomeController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedBill = Income()
    var title2 = ""
    var amount2 = 0.00
    var date2 = Date()
    var validationResult = true
    @IBOutlet weak var title1: UITextField!
    @IBOutlet weak var amount1: UITextField!
    
    @IBOutlet weak var date1: UIDatePicker!
    
    //MARK: show the correct title, amount, and date as the placeholder in the edit income view
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title1.text = selectedBill.title
        amount1.text = "\(selectedBill.amount)"
        date1.date = selectedBill.date!
    }
    
    //MARK: When editIncome button is clicked the changeMade function is called which will take the data entered in the text fields. Search by the title, take the first result and change the title, amount, date and save into the context. Create an alert and send back to income controller
    
    @IBAction func editIncome(_ sender: Any) {
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
    
    //MARK: Validate input price
    
    func validatePrice(price:String)->Bool{
        let priceRegex = #"(\-?\d+\.?\d{0,2})"#
        let result = price.range(
            of: priceRegex,
            options: .regularExpression
        )
        let validate = (result != nil)
        return validate
    }
    
    //MARK: Track the changes made and populate them in Core Data
    
    func changeMade(){
        title2 = title1.text!
        amount2 = Double(amount1.text!)!
        date2 = date1.date
        
        var bill = selectedBill
        var fetchrequest: NSFetchRequest<Income> = Income.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "title = %@",selectedBill.title!)
        let results = try? context.fetch(fetchrequest)
        if results?.count == 0{
            bill = Income(context: context)
        }else{
            bill = (results?.first)!
        }
        
        bill.title = title2
        bill.amount = amount2
        bill.date = date2
        do{
        try context.save()
        }catch{}
        createAlert(title:"Editted Income",msg:"Your income has been successfully editted!")
    }
    
    //MARK: Create alert with a Done button then send back to the income controller
    
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{ (action: UIAlertAction!) in
            _=self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion:nil)}
    
    //MARK: Create alert for invalid input
    
    func displayAlert(){
        let missingInformationAlert = UIAlertController(title: "Missing Information!",
                                                        message: "Make sure all the fields are filled",
                                                        preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        missingInformationAlert.addAction(cancelAction)
        self.present(missingInformationAlert, animated: true, completion: nil)
    }
    
    //MARK: Create alert for empty input
    
    func showAlert(){
        let alert = UIAlertController(title:"invalid input!", message:"Make sure your input is correct",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",style:.cancel))
        present(alert, animated:true)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
