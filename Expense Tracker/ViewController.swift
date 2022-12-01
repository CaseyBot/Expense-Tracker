//
//  ViewController.swift
//  Expense Tracker
//
//  Created by student on 10/4/22.
//
import UIKit
import CoreData
import SwiftUI
class ViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var homeView: UITableView!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var expenseAmount: UILabel!
    @IBOutlet weak var incomeAmount: UILabel!
    @IBOutlet weak var summaryTable: UITableView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var progressText: UILabel!
    @IBOutlet weak var bottomHalf: UITextView!
    var expenseBills:[Expense] = []
    var incomeBills:[Income] = []
    var summaryBills:[Summary] = []
    var budgetBills:[Budget] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: Reload all databases when called
    
    func reloadData(){
        fetchBills()
        fetchIncome()
        fetchSummary()
        DispatchQueue.main.async(execute:{self.summaryTable.reloadData()})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.layer.cornerRadius = 10
        summaryTable.delegate = self
        summaryTable.dataSource = self
        fetchBills()
        fetchIncome()
        fetchBudget()
        fetchSummary()
        
        //MARK: Calculate total expenses, income and budget
        
        var totalIncome = 0.0
        for incomeBill in incomeBills {
            totalIncome += incomeBill.amount
        }
        var totalExpense = 0.0
        for bill in expenseBills {
            totalExpense += bill.amount
        }
        
        //MARK: Calclulate current balance
        
        balance.text = "$\(round((totalIncome-totalExpense)*100)/100)"
        expenseAmount.text = "$\(round(totalExpense*100)/100)"
        incomeAmount.text = "$\(round(totalIncome*100)/100)"
        self.summaryTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        var totalBudget = Double(0.0)
        for budget in budgetBills{
            totalBudget = totalBudget + budget.budget
        }
        
        //MARK: Calculate progress bar value
        
        var targetAmount = totalBudget - totalExpense
        if totalIncome == 0 && totalExpense == 0 && totalBudget == 0{
            progressText.text! = "You have no transactions"
            progressBar.progress = Float(0.0)
        }
        else if totalIncome<totalExpense{
            progressText.text! = "Your income exceeds expenses"
            progressBar.progress = (Float(totalBudget)-Float(0.0))/(Float(totalBudget)-Float(0.0))
        }
        else if targetAmount>0{
            progressText.text! = "$\(targetAmount) left of $\(totalBudget) budget"
            progressBar.progress = (Float(totalExpense)-Float(0.0))/(Float(totalBudget)-Float(0.0))
        }
        else if targetAmount<0{
            progressText.text! = "You've exceeded budget by $\(  totalExpense-totalBudget)"
            print(totalExpense-totalBudget)
            print("expense")
            print(totalExpense)
            print("budget")
            print(totalBudget)
            progressBar.progress = (Float(totalBudget)-Float(0.0))/(Float(totalBudget)-Float(0.0))
        }
        
        //MARK: Uncomment to clear database
//        deleteAllData(entity: "Expense")
//        deleteAllData(entity: "Summary")
//        deleteAllData(entity: "Summary")
        summaryTable.reloadData()
       
    }
    
    //MARK: Function to clear database and restart
    
    func deleteAllData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    //MARK:  Reloads table when screen appears
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidLoad()
        summaryTable.reloadData()
    }
    
    //MARK: Fetches expense details
    
    func fetchBills(with request: NSFetchRequest<Expense> = Expense.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            expenseBills = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    
    //MARK: Fetch income details

    func fetchIncome(with request: NSFetchRequest<Income> = Income.fetchRequest()){
        do{
            incomeBills = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    
    //MARK: Fetch budget details
    
    func fetchBudget(with request: NSFetchRequest<Budget> = Budget.fetchRequest()){
        do{
            budgetBills = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    
    //MARK: Fetch account summary to be presented on the main screen
    
    func fetchSummary(with request: NSFetchRequest<Summary> = Summary.fetchRequest()){
        //Fetch the data from Core Data to display in the tableview
        //Populate the summary database
        do{
            var summaryData:[Summary] = []

            for expense in expenseBills{
                let newSummary = Summary(context: self.context)
                newSummary.amount = expense.amount
                newSummary.title = expense.title
                newSummary.type = expense.type
                newSummary.date = expense.date
                summaryData.append(newSummary)
            }
            
            for income in incomeBills{
                let newSummary = Summary(context: self.context)
                newSummary.amount = income.amount
                newSummary.title = income.title
                newSummary.type = income.type
                newSummary.date = income.date
                summaryData.append(newSummary)
            }
            
            summaryBills = summaryData
            //MARK: Sort summary data by data
            summaryBills.sort(by: { $0.date! > $1.date! })
            DispatchQueue.main.async{
                self.summaryTable.reloadData()
            }
        }catch{
            print(error)
        }
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //MARK: Image for empty screen
        if summaryBills.count == 0{
            let image = UIImage(named: "main")
            let noDataImage = UIImageView(image: image)
            noDataImage.frame = CGRect(x: 0, y: 0, width: summaryTable.bounds.width, height: summaryTable.bounds.height)
            noDataImage.contentMode = .scaleAspectFit
            noDataImage.layer.opacity = 0.03
            summaryTable.addSubview(noDataImage)
            summaryTable.separatorStyle = .none

        }else{
            summaryTable.backgroundView = nil
            summaryTable.separatorStyle = .none
            for subview in summaryTable.subviews {
                subview.removeFromSuperview()
            }
        }
         return summaryBills.count
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: Set cell values with appropriate formatting
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath)
        let exp = cell.viewWithTag(10) as! UILabel
        let amount = cell.viewWithTag(11) as! UILabel
        let date = cell.viewWithTag(12) as! UILabel

        let expense = self.summaryBills[indexPath.row]
        exp.text = expense.title
        
        date.text = "\(expense.date!.formatted(date: .abbreviated, time: .omitted))"
        if expense.type != nil{
            amount.textColor = UIColor(red: 191/255.0, green: 32/255.0, blue: 27/255.0, alpha: 1);
            amount.text = "-$\(round(expense.amount*100.0/100.0))"
        }
        else{
            amount.textColor = UIColor(red: 4/255.0, green: 128/255.0, blue: 49/255.0, alpha: 1)
            amount.text = "+$\(round(expense.amount*100.0/100.0))"
        }
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
        let expense = self.summaryBills[indexPath.row]

        if editingStyle == UITableViewCell.EditingStyle.delete{
            summaryTable.beginUpdates()
            context.delete(expense)
            do{
                try context.save()
                summaryTable.reloadData()
            }catch {
                print("Error While deleting")
            }
            summaryTable.endUpdates()
        }
    }

}
