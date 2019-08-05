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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        let newItem = Item()
        newItem.itemText = "dor"
        itemArr.append(newItem)
        loadData()
        

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
            itemArr.remove(at: indexPath.row)
            saveData()
        }
    }
    
    @IBAction func AddItemBTN(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item to your ToDo list", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let newItem = Item()
            newItem.itemText = textField.text!
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArr)
            try data.write(to: self.dataFilePath!)
            
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadData (){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            
            do{
                itemArr = try decoder.decode([Item].self, from: data)
            }catch{
                print(error)
            }
        }
        tableView.reloadData()
    }
    
    
}

