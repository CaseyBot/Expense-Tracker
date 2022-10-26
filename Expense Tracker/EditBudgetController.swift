//
//  EditBudgetController.swift
//  Expense Tracker
//
//  Created by student on 10/26/22.
//

import UIKit
import CoreData

class EditBudgetController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedBill = Budget()
    var title2 = ""
    var amount2 = 0.00
    @IBOutlet weak var title1: UITextField!
    
    @IBOutlet weak var amount1: UITextField!
    
    @IBAction func edit(_ sender: Any) {
        changeMade()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title1.text = selectedBill.type
        amount1.text = "\(selectedBill.amount)"
        // Do any additional setup after loading the view.
    }
    func changeMade(){
        title2 = title1.text!
        amount2 = Double(amount1.text!)!

        
        var bill = selectedBill
        var fetchrequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "type = %@",selectedBill.type!)
        let results = try? context.fetch(fetchrequest)
        if results?.count == 0{
            bill = Budget(context: context)
        }else{
            bill = (results?.first)!
        }
        
        bill.type = title2
        bill.amount = amount2
        do{
        try context.save()
        }catch{}
        createAlert(title:"Edited Budget",msg:"Your budget has been successfully editted!")

        _ = navigationController?.popToRootViewController(animated: true)
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
