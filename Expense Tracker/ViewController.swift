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
    
    @IBOutlet weak var homeView: UITableView!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var expenseAmount: UILabel!
    @IBOutlet weak var incomeAmount: UILabel!
    @IBOutlet weak var summaryTable: UITableView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var bottomHalf: UITextView!
    var expenseBills:[Expense] = []
    var incomeBills:[Income] = []
    var summaryBills:[Summary] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func reloadData(){
        fetchBills()
        fetchIncome()
        fetchSummary()
        DispatchQueue.main.async(execute:{self.summaryTable.reloadData()})
    }
    
    override func viewDidLoad() {
        ///
        super.viewDidLoad()
//        summaryTable.delegate = self
//        summaryTable.dataSource = self
        summaryTable.delegate = self
        summaryTable.dataSource = self
        fetchBills()
        fetchIncome()
        fetchSummary()
        summaryTable.reloadData()
        var totalIncome = 0.0
        for incomeBill in incomeBills {
            totalIncome += incomeBill.amount
        }
        var totalExpense = 0.0
        for bill in expenseBills {
            totalExpense += bill.amount
        }
        balance.text = "$\(round((totalIncome-totalExpense)*100)/100)"
        expenseAmount.text = "$\(round(totalExpense*100)/100)"
        incomeAmount.text = "$\(round(totalIncome*100)/100)"
        self.summaryTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        progressBar.layer.cornerRadius = 10
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidLoad()
        reloadData()
    }
    
    func fetchBills(with request: NSFetchRequest<Expense> = Expense.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            expenseBills = try context.fetch(request)
            //print(bills[7].title)
        }catch{
            print(error)
        }
    }
    

    func fetchIncome(with request: NSFetchRequest<Income> = Income.fetchRequest()){
        do{
            incomeBills = try context.fetch(request)
//            DispatchQueue.main.async{
//                self.summaryTable.reloadData()
//            }
            //print(incomeBills[1].title)
        }catch{
            print(error)
        }
    }
    
    func fetchSummary(with request: NSFetchRequest<Summary> = Summary.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            summaryBills = try context.fetch(request)
            summaryBills.sort(by: { $0.date! > $1.date! })

            DispatchQueue.main.async{
                self.summaryTable.reloadData()
            }
            //print(bills[7].title)
        }catch{
            print(error)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if summaryBills.count == 0{
            let image = UIImage(named: "main")
            let noDataImage = UIImageView(image: image)
            noDataImage.frame = CGRect(x: 0, y: 0, width: summaryTable.bounds.width, height: summaryTable.bounds.height)
            noDataImage.contentMode = .scaleAspectFit
            noDataImage.layer.opacity = 0.3
            summaryTable.addSubview(noDataImage)

            //summaryTable.backgroundView = noDataImage
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath)

            //cell.delegate = self
        let exp = cell.viewWithTag(10) as! UILabel
        let amount = cell.viewWithTag(11) as! UILabel
        let date = cell.viewWithTag(12) as! UILabel

        let expense = self.summaryBills[indexPath.row]
        exp.text = expense.title
        
        date.text = "\(expense.date!.formatted(date: .abbreviated, time: .omitted))"
        if expense.type == "Expense"{
            amount.textColor = UIColor(red: 191/255.0, green: 32/255.0, blue: 27/255.0, alpha: 1);
            amount.text = "-$\(expense.amount)"
        }
        else{
            amount.textColor = UIColor(red: 4/255.0, green: 128/255.0, blue: 49/255.0, alpha: 1)
            amount.text = "+$\(expense.amount)"
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
            //expenseTable.reloadData()
            do{
                try context.save()
                reloadData()
                summaryTable.reloadData()
                //self.expenseTable.deleteRows(at: [indexPath], with: .automatic)
                
            }catch {
                print("Error While deleting")
            }
            summaryTable.endUpdates()
            //tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            

        }
    }

}
