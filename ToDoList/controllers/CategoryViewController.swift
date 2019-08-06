//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Dor Zafrir on 06/08/2019.
//  Copyright © 2019 Dor Zafrir. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArr = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadData()
        
    }
    
    @IBAction func addCategory(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new Category to your list", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.category = textField.text
            self.categoryArr.append(newCategory)
            self.saveData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //    MARK:- tableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        let category = categoryArr[indexPath.row].category
        cell.textLabel?.text = category
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: .none)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArr[indexPath.row]
        }
    }
    
    func configureTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            context.delete(categoryArr[indexPath.row])
            categoryArr.remove(at: indexPath.row)
            saveData()
        }
    }
    
    //    MARK:- data methods
    
    func saveData(){
        do {
            try context.save()
        }catch{
            print("error saving category: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData (with request : NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryArr =  try context.fetch(request)
        } catch {
            print("error reloading category: \(error)")
        }
        tableView.reloadData()
    }
}

