//
//  ViewController.swift
//  ToDoList
//
//  Created by Dor Zafrir on 04/08/2019.
//  Copyright © 2019 Dor Zafrir. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController  {
    
    var itemArr = [Item]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        let newItem = Item()
        newItem.itemText = "dor"
        itemArr.append(newItem)
        
        if let items = defaults.array(forKey: "itemArr") as? [Item]{
            itemArr = items
        }
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
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            itemArr.remove(at: indexPath.row)
            self.defaults.set(self.itemArr, forKey: "itemArr")
            tableView.reloadData()
        }
    }
    
    @IBAction func AddItemBTN(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item to your ToDo list", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let newItem = Item()
            newItem.itemText = textField.text!
            self.itemArr.append(newItem)
            //            self.defaults.set(self.itemArr, forKey: "itemArr")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

