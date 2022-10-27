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
    var title2 = ""
    var amount2 = 0.00
    @IBOutlet weak var title1: UITextField!
    
    @IBOutlet weak var amount1: UITextField!
    //Edit button to trigget the changeMade() event and show the core data information in the viewDidLoad function within the dit budget controller in main
    @IBAction func edit(_ sender: Any) {
        changeMade()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title1.text = selectedBill.type
        amount1.text = "\(selectedBill.amount)"
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
        bill.amount = amount2
        do{
        try context.save()
        }catch{}
        createAlert(title:"Edited Budget",msg:"Your budget has been successfully editted!")

    }
    //Create alert with done button and return back to the budget controller
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{ (action: UIAlertAction!) in
            _=self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion:nil)}


}
