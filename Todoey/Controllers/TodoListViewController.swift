//
//  ViewController.swift
//  Todoey
//
//  Created by Vincent Tsang on 7/3/18.
//  Copyright © 2018 Vincent Tsang. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    let KEY_ITEMS_ARR = "TodoListArray"
    let realm = try! Realm()
    var items : Results<Item>?

    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let category = selectedCategory else {fatalError()}
        title = category.name
        updateNavBar(withHexCode: category.color)
        searchBar.barStyle = .blackOpaque
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D98F6")
    }
    
    func updateNavBar(withHexCode colorHexCode : String) {
        guard let navbar = navigationController?.navigationBar else {fatalError()}
        guard let navbarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        
        navbar.tintColor = ContrastColorOf(navbarColor, returnFlat: true)
        navbar.barTintColor = navbarColor
        navbar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navbarColor, returnFlat: true)]
        
        searchBar.barTintColor = navbarColor
    }

    // MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let currCategory = selectedCategory {
            if let item = items?[indexPath.row] {
                cell.textLabel?.text = item.title
                cell.accessoryType = item.isDone ? .checkmark : .none
            
                if let color = UIColor(hexString: currCategory.color)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(items!.count))) {
                    cell.backgroundColor = color
                    cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                }
                
            } else {
                cell.textLabel?.text = "No Items added"
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.isDone = !item.isDone
                }
            } catch {
                print("Error writing item \(error)")
            }
             self.tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    
    // MARK: - Add Todo Items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let category = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        category.items.append(newItem)
                    }
                } catch {
                    print("Error writing item \(error)")
                }
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = selectedCategory?.items[indexPath.row]{
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }
    
    // MARK: - Model Manipulation Methods
    
    func loadData() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

// MARK: - Search Bar Delegate Methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            print("reset")

            loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

