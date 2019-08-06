//
//  ViewController.swift
//  ToDoList
//
//  Created by Dor Zafrir on 04/08/2019.
//  Copyright © 2019 Dor Zafrir. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController  {
    
    var itemArr = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArr[indexPath.row]
        cell.textLabel?.text = item.itemText
        
        cell.accessoryType = item.isChecked ? .checkmark : .none
        
        return cell
    }
    
    func configureTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArr[indexPath.row].isChecked = !itemArr[indexPath.row].isChecked
        tableView.deselectRow(at: indexPath, animated: true)
        saveData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            context.delete(itemArr[indexPath.row])
            itemArr.remove(at: indexPath.row)
            saveData()
        }
    }
    
    
    
    
    
    @IBAction func addItemBTN(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item to your ToDo list", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            
            let newItem = Item(context: self.context)
            newItem.itemText = textField.text!
            newItem.isChecked = false
            newItem.parentCategory = self.selectedCategory
            self.itemArr.append(newItem)
            self.saveData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveData (){
        do {
            try context.save()
        }catch{
            print("error saving context: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData (with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.category MATCHES %@", selectedCategory!.category!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArr =  try context.fetch(request)
        } catch {
            print("error reloading data: \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - extensions

extension ToDoViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0{
            loadData()
        }else {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "itemText CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "itemText", ascending: true)]
        loadData(with: request, predicate: predicate)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
    
}

