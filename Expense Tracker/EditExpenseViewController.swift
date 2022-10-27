//
//  EditExpenseViewController.swift
//  Expense Tracker
//
//  Created by student on 10/24/22.
//

import UIKit
import CoreData
//Create the objects from expense and context, create the variables to insert into the core data, transfer over all of the textfields from the main view
class EditExpenseViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedBill = Expense()
    var title2 = ""
    var amount2 = 0.00
    var type2 = ""
    var date2 = Date()
    @IBOutlet weak var title1: UITextField!
    @IBOutlet weak var amount1: UITextField!
    @IBOutlet weak var type1: UITextField!
    @IBOutlet weak var date1: UIDatePicker!
    //Transfer function from the editChanges button that is clicked
    @IBAction func editChanges(_ sender: Any) {
        changeMade()
        
    }
    //In the override viewDidLoad show the information from the core data for the row selected and change if the user decides to.
    override func viewDidLoad() {
        super.viewDidLoad()
        title1.text = selectedBill.title
        amount1.text = "\(selectedBill.amount)"
        type1.text = selectedBill.type
        date1.date = selectedBill.date!
        
    }
    //Get the text from the labels, request the expense object, search by title then take the first result and change the title, amount, type, and date as to what the user wants. Then saves the context and creates an alert. Send back to the expense controller
    func changeMade(){
        title2 = title1.text!
        amount2 = Double(amount1.text!)!
        type2 = type1.text!
        date2 = date1.date
        
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
        do{
        try context.save()
        }catch{}
        createAlert(title:"Edited Expense",msg:"Your expense has been successfully editted!")

        

    }
    //Create the alert for done and dismiss the the alert when it is clicked
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{ (action: UIAlertAction!) in
            _=self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion:nil)}
}
