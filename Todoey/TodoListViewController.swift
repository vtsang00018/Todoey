//
//  ViewController.swift
//  Todoey
//
//  Created by Vincent Tsang on 7/3/18.
//  Copyright © 2018 Vincent Tsang. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Optimus Prime", "Starscream", "SideSwipe"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

