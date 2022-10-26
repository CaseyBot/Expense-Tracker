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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
