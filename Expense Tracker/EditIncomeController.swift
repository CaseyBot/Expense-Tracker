//
//  EditIncomeController.swift
//  Expense Tracker
//
//  Created by student on 10/24/22.
//

import UIKit
import CoreData

class EditIncomeController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedBill = Income()
    var title2 = ""
    var amount2 = 0.00
    var date2 = Date()
    
    @IBOutlet weak var title1: UITextField!
    @IBOutlet weak var amount1: UITextField!
    
    @IBOutlet weak var date1: UIDatePicker!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title1.text = selectedBill.title
        amount1.text = "\(selectedBill.amount)"
        date1.date = selectedBill.date!
        // Do any additional setup after loading the view.
    }
    
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
        
        _ = navigationController?.popToRootViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
