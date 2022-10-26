//
//  EditExpenseViewController.swift
//  Expense Tracker
//
//  Created by student on 10/24/22.
//

import UIKit
import CoreData

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
    @IBAction func editChanges(_ sender: Any) {
        changeMade()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title1.text = selectedBill.title
        amount1.text = "\(selectedBill.amount)"
        type1.text = selectedBill.type
        date1.date = selectedBill.date!
        
    }
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

        
        _ = navigationController?.popToRootViewController(animated: true)
    }
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{_ in self.dismiss(animated: true, completion:nil)}))
        self.present(alert, animated: true, completion:nil)}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
