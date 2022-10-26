//
//  IncomeViewController.swift
//  Expense Tracker
//
//  Created by student on 10/23/22.
//

import UIKit
import CoreData
class IncomeViewController: UIViewController  {
    
    var bills:[Income] = []
    var selectedIn = Income()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var totalExpenses: UILabel!
    
    @IBOutlet weak var incomeTable: UITableView!
    func reloadData(){
        DispatchQueue.main.async(execute:{self.incomeTable.reloadData()})
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "IncomeToEdit"{
            let detailed_view = segue.destination as! EditIncomeController
            detailed_view.selectedBill = selectedIn
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        incomeTable.delegate = self
        incomeTable.dataSource = self
        fetchBills()
        incomeTable.reloadData()
        // Do any additional setup after loading the view.
        
        
        //To Delete Everything in Expenses
        
        //for object in bills!{
           // context.delete(object)
       // }
        
        //do{
        //    try context.save()
       // }catch{}
        
    }
    override func viewDidAppear(_ animated: Bool) {
        reloadData()
    }
    func fetchBills(with request: NSFetchRequest<Income> = Income.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            bills = try context.fetch(request)
            DispatchQueue.main.async{
                self.incomeTable.reloadData()
            }
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


extension IncomeViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bills.count
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath)
        
            //cell.delegate = self
        let exp = cell.viewWithTag(7) as! UILabel
        let amount = cell.viewWithTag(9) as! UILabel
        let date = cell.viewWithTag(8) as! UILabel
        
        let expense = self.bills[indexPath.row]
        exp.text = expense.title
        amount.text = "\(expense.amount)"
        date.text = "\(expense.date!.formatted(date: .abbreviated, time: .omitted))"
            return cell
        }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       let expense = self.bills[indexPath.row]

       if editingStyle == UITableViewCell.EditingStyle.delete{
           incomeTable.beginUpdates()
           context.delete(expense)
           //expenseTable.reloadData()
           do{
               try context.save()
               //reloadData()
               //self.expenseTable.deleteRows(at: [indexPath], with: .automatic)
               
           }catch {
               print("Error While deleting")
           }
           incomeTable.endUpdates()
           //tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
           self.viewDidLoad()

       }
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
       selectedIn = bills[indexPath.row]
       self.performSegue(withIdentifier: "IncomeToEdit", sender: self)
   }
    
    
}
