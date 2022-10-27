//
//  EditIncomeController.swift
//  Expense Tracker
//
//  Created by student on 10/24/22.
//

import UIKit
import CoreData
//create the object variables and variables for the title, amount, and data from the text fields
class EditIncomeController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedBill = Income()
    var title2 = ""
    var amount2 = 0.00
    var date2 = Date()
    
    @IBOutlet weak var title1: UITextField!
    @IBOutlet weak var amount1: UITextField!
    
    @IBOutlet weak var date1: UIDatePicker!
    //show the correct title, amount, and date as the placeholder in the edit income view
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title1.text = selectedBill.title
        amount1.text = "\(selectedBill.amount)"
        date1.date = selectedBill.date!
        // Do any additional setup after loading the view.
    }
    //When editIncome button is clicked the changeMade function is called which will take the data entered in the text fields. Search by the title, take the first result and change the title, amount, date and save into the context. Create an alert and send back to income controller
    @IBAction func editIncome(_ sender: Any) {
        changeMade()

    }
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
    //Create alert with a Done button then send back to the income controller
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{ (action: UIAlertAction!) in
            _=self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion:nil)}
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
