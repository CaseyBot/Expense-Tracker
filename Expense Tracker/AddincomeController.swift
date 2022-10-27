//
//  AddincomeController.swift
//  Expense Tracker
//
//  Created by Sneha Seenuvasavarathan on 10/22/22.
//

import UIKit
import CoreData

class AddincomeController: UIViewController {

  //Add all of the income inputs and add the objects for expenses and summary entities and context
    @IBOutlet weak var incomeTitle: UITextField!
    @IBOutlet weak var incomeAmount: UITextField!
    @IBOutlet weak var incomeDate: UIDatePicker!
    
    var bills:[Income] = []
    var summary:[Summary] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBills()
        // Do any additional setup after loading the view.
    }
    //Add Income Button for new expense for the expense entity and also add it to the summary entity. Create the alert after adding
    @IBAction func addIncomeButton(_ sender: Any) {
        let newIncome = Income(context: self.context)
        newIncome.title = incomeTitle.text!
        newIncome.amount = Double(incomeAmount.text!) ?? 0.0
        newIncome.date = incomeDate.date
        self.bills.append(newIncome)
        saveBills()
        let newSummary = Summary(context: self.context)
        newSummary.title = incomeTitle.text!
        newSummary.amount = Double(incomeAmount.text!) ?? 0.0
        newSummary.type = "Income"
        newSummary.date = incomeDate.date
        self.summary.append(newSummary)
        saveSummary()
        createAlert(title:"Added Income",msg:"Your income has been successfully added!")

    }
    //Save bills  into context and fetch the income object
    func saveBills(){
        do {
                    try context.save()
                } catch {
                    print("Error saving context \(error)")
                }
        
    }
    func fetchBills(with request: NSFetchRequest<Income> = Income.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            bills = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    //Save into summary context and fetch the summary object and save it as well
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
    //Create alert with Done button and send back to income view controller
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{ (action: UIAlertAction!) in
            _=self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion:nil)}


}
