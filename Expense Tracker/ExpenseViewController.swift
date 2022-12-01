//
//  ExpenseViewController.swift
//  Expense Tracker
//
//  Created by Sneha Seenuvasavarathan on 10/23/22.
//

import UIKit
import CoreData

class ExpenseViewController: UIViewController  {
    //Expense entity to change later and context
    var bills:[Expense]?
    var selectedBill = Expense()
    var budget:[Budget]?
    @IBOutlet weak var background1: UITextView!
    @IBOutlet weak var background2: UITextView!
    var gradient = CAGradientLayer()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var totalExpenses: UILabel!
    @IBOutlet weak var expenseTable: UITableView!
    //In the viewDidLoad the delegate and datasource are made to self. Reload the data and set expense to 0 while increasing amount. Set to keep the overall amounts up to date
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseTable.delegate = self
        expenseTable.dataSource = self
        fetchBills()
        fetchBudget()
        expenseTable.reloadData()
        var expense = 0.0
        for expenseBill in bills! {
            expense += expenseBill.amount
        }
        totalExpenses.text = "$\(round(expense*100)/100)"

        // Do any additional setup after loading the view.
        //To Delete Everything in Expenses
        //for object in bills!{
           // context.delete(object)
       // }
        
        //do{
        //    try context.save()
       // }catch{}
    }
    //Reload the data for the expense table
    func reloadData(){
        fetchBills()
        fetchBudget()
        DispatchQueue.main.async(execute:{self.expenseTable.reloadData()})
    }
    
    //Prepare the segue, send the current row to EditExpenseController and set the destination
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ExpenseToEdit"{
            let detailed_view = segue.destination as! EditExpenseViewController
            detailed_view.selectedBill = selectedBill
            
        }
    }
    //viewDidAppear needed to refresh the view when changes are made and fetch the expense data and table
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
    func fetchBudget(with request: NSFetchRequest<Budget> = Budget.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            budget = try context.fetch(request)
            
        }catch{
            print(error)
        }
        
    }


}

//Make changes to the table including the size, amount of rows and cell specifications to change the different labels and changing the date format then return the cell
extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bills!.count == 0{
            let image = UIImage(named: "expense")
            let noDataImage = UIImageView(image: image)
            noDataImage.frame = CGRect(x: 0, y: 0, width: expenseTable.bounds.width, height: expenseTable.bounds.height)
            noDataImage.layer.opacity = 0.3
            noDataImage.contentMode = .scaleAspectFit
            expenseTable.backgroundView = noDataImage
            expenseTable.separatorStyle = .none
            
        }else{
            expenseTable.backgroundView = nil
            expenseTable.separatorStyle = .singleLine
        }
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

    //Delete function to swipe to the left then reload the table and core data then reload the data
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         var expense = self.bills![indexPath.row]
         print(expense.amount)
         for b in budget!{
             if b.type == expense.type{
                 var bill = b
                 var fetchrequest: NSFetchRequest<Budget> = Budget.fetchRequest()
                 fetchrequest.predicate = NSPredicate(format: "type = %@",b.type!)
                 let results = try? context.fetch(fetchrequest)
                 if results?.count == 0{
                     bill = Budget(context: context)
                 }else{
                     bill = (results?.first)!
                 }
                 if (bill.amount + expense.amount) > bill.budget{
                     bill.amount = bill.budget
                 }
                 else{
                 bill.amount = bill.amount + expense.amount
                 }
                 do{
                 try context.save()
                 }catch{}
             }
         }
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
    //perform the segue for row selected and send the row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        selectedBill = bills![indexPath.row]
        self.performSegue(withIdentifier: "ExpenseToEdit", sender: self)
        
    }

}
