//
//  AddincomeController.swift
//  Expense Tracker
//
//  Created by Sneha Seenuvasavarathan on 10/22/22.
//

import UIKit
import CoreData

class AddincomeController: UIViewController {

    
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
        _ = navigationController?.popToRootViewController(animated: true)

    }
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
