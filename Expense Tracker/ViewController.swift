//
//  ViewController.swift
//  Expense Tracker
//
//  Created by student on 10/4/22.
//
import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var homeView: UITableView!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var expenseAmount: UILabel!
    @IBOutlet weak var incomeAmount: UILabel!
    
    var bills:[Expense] = []
    var incomeBills:[Income] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        ///
        super.viewDidLoad()
        
        homeView.delegate = self
        homeView.dataSource = self
        fetchBills()
        fetchIncome()
        var totalIncome = 0.0
        for incomeBill in incomeBills {
            totalIncome += incomeBill.amount
        }
        var totalExpense = 0.0
        for bill in bills {
            totalExpense += bill.amount
        }
        balance.text = "\(totalIncome-totalExpense)"
        expenseAmount.text = "\(totalExpense)"
        incomeAmount.text = "\(totalIncome)"
    }

    
    func fetchBills(with request: NSFetchRequest<Expense> = Expense.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            bills = try context.fetch(request)
            //print(bills[7].title)
        }catch{
            print(error)
        }
    }
    
    func fetchIncome(with request: NSFetchRequest<Income> = Income.fetchRequest()){
        do{
            incomeBills = try context.fetch(request)
            //print(incomeBills[1].title)
        }catch{
            print(error)
        }
    }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
       return 0
    }

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.delegate = self
        
        return cell
    }
    


}

