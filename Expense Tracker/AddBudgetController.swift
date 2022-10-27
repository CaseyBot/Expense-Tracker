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

    @IBOutlet weak var title1: UITextField!
    
    @IBOutlet weak var amount1: UITextField!
    //add function button that saves the new budget entity and append it to the expense object then create the alert for the budget that are added then return to the prior controller
    @IBAction func add(_ sender: Any) {
        let newExpense = Budget(context: self.context)
        newExpense.type = title1.text!
        newExpense.amount = Double(amount1.text!) ?? 0.0
        self.bills.append(newExpense)
        saveBills()
        createAlert(title:"Added Budget",msg:"Your budget has been successfully added!")


        
    }
    //Create the budget entity and context then viewDidLoad and fetch bills function
    var bills:[Budget] = []

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBills()

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
    
    func fetchBills(with request: NSFetchRequest<Budget> = Budget.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            bills = try context.fetch(request)
            
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

}
