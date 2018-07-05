//
//  ViewController.swift
//  Todoey
//
//  Created by Vincent Tsang on 7/3/18.
//  Copyright © 2018 Vincent Tsang. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let KEY_ITEMS_ARR = "TodoListArray"
    
    var itemArray = [TodoItem]()
    
    var defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemOne = TodoItem()
        itemOne.title = "Optimus Prime"
        itemArray.append(itemOne)
        
        let itemTwo = TodoItem()
        itemTwo.title = "Megatron"
        itemArray.append(itemTwo)
        
        let itemThree = TodoItem()
        itemThree.title = "BumbleBee"
        itemArray.append(itemThree)
        
        let ItemFour = TodoItem()
        ItemFour.title = "StarScream"
        itemArray.append(ItemFour)
        
        let ItemFive = TodoItem()
        ItemFive.title = "Place"
        
        if let items = defaults.array(forKey: KEY_ITEMS_ARR) as? [TodoItem]{
            itemArray = items
        }
    }

    // Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currItem = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)
        cell.textLabel?.text = currItem.title
        
        cell.accessoryType = currItem.isDone ? .checkmark : .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let currItem = itemArray[indexPath.row]
        let currAccessory = tableView.cellForRow(at: indexPath)?.accessoryType
        
        currItem.isDone = !currItem.isDone
        
        tableView.cellForRow(at: indexPath)?.accessoryType =
            currAccessory == .checkmark ? .none : .checkmark

        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Add New Items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = TodoItem()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: self.KEY_ITEMS_ARR)
            
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

