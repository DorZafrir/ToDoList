//
//  ViewController.swift
//  ToDoList
//
//  Created by Dor Zafrir on 04/08/2019.
//  Copyright © 2019 Dor Zafrir. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController  {
    
    let missionsArr = ["feed the dog","take down the garbage","cook dinner"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionsArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = missionsArr[indexPath.row]
        return cell
    }
    
    func configureTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
}

