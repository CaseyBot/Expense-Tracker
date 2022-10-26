//
//  AddBudgetController.swift
//  Expense Tracker
//
//  Created by student on 10/26/22.
//

import UIKit
import CoreData

class AddBudgetController: UIViewController {

    @IBOutlet weak var title1: UITextField!
    
    @IBOutlet weak var amount1: UITextField!
    
    @IBAction func add(_ sender: Any) {
        let newExpense = Budget(context: self.context)
        newExpense.type = title1.text!
        newExpense.amount = Double(amount1.text!) ?? 0.0
        self.bills.append(newExpense)
        saveBills()

        //self.performSegue(withIdentifier: "seg_expense_to_add", sender: self)

        createAlert(title:"Added Budget",msg:"Your budget has been successfully added!")

        _ = navigationController?.popToRootViewController(animated: true)


        
    }
    var bills:[Budget] = []

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBills()

        // Do any additional setup after loading the view.
    }
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
