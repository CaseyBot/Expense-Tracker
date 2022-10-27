//
//  ExpenseViewController.swift
//  Expense Tracker
//
//  Created by Sneha Seenuvasavarathan on 10/23/22.
//

import UIKit
import CoreData

class ExpenseViewController: UIViewController  {
    
    var bills:[Expense]?
    var selectedBill = Expense()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var totalExpenses: UILabel!
    @IBOutlet weak var expenseTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseTable.delegate = self
        expenseTable.dataSource = self
        fetchBills()
        expenseTable.reloadData()
        var expense = 0.0
        for expenseBill in bills! {
            expense += expenseBill.amount
        }
        totalExpenses.text = "$\(round(expense*100)/100)"
        self.expenseTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        // Do any additional setup after loading the view.
        //To Delete Everything in Expenses
        //for object in bills!{
           // context.delete(object)
       // }
        
        //do{
        //    try context.save()
       // }catch{}
        
    }
    
    func reloadData(){
        fetchBills()
        DispatchQueue.main.async(execute:{self.expenseTable.reloadData()})
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ExpenseToEdit"{
            let detailed_view = segue.destination as! EditExpenseViewController
            detailed_view.selectedBill = selectedBill
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidLoad()
        self.expenseTable.reloadData()
    }

    func fetchBills(with request: NSFetchRequest<Expense> = Expense.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            
            bills = try context.fetch(request)
            DispatchQueue.main.async{
                self.expenseTable.reloadData()
            }
        }catch{
            print(error)
        }
    }

}


extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills!.count
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath)
        let exp = cell.viewWithTag(4) as! UILabel
        let amount = cell.viewWithTag(6) as! UILabel
        let date = cell.viewWithTag(5) as! UILabel
        
        let expense = self.bills![indexPath.row]
        exp.text = expense.title
        amount.text = "-$\(expense.amount)"
        amount.textColor = UIColor(red: 191/255.0, green: 32/255.0, blue: 27/255.0, alpha: 1);
        date.text = "\(expense.date!.formatted(date: .abbreviated, time: .omitted))"
        switch indexPath.row % 2 {
        case 0:
            cell.backgroundColor = UIColor(red: 244/255.0, green: 243/255.0, blue: 247/255.0, alpha: 1);
        case 1:
            cell.backgroundColor = UIColor(red: 251/255.0, green: 251/255.0, blue: 254/255.0, alpha: 1);
        default:
            cell.backgroundColor = .white
        }
            return cell
    }


     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         var expense = self.bills![indexPath.row]


        if editingStyle == UITableViewCell.EditingStyle.delete{
            expenseTable.beginUpdates()
            
            //self.expenseTable.deleteRows(at: [indexPath], with: .automatic)
            
            context.delete(expense)

            //expenseTable.reloadData()
            do{
                try context.save()

                
            }catch {
                print("Error While deleting")
            }
            expenseTable.endUpdates()
            //tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            self.viewDidLoad()

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        selectedBill = bills![indexPath.row]
        self.performSegue(withIdentifier: "ExpenseToEdit", sender: self)
        
    }
}
