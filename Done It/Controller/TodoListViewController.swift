//
//  ViewController.swift
//  Done It
//
//  Created by Sydney Beal on 9/18/18.
//  Copyright © 2018 Sydney Beal. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    // MARK: - Global constants
    
    // array of Done It items
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    // MARK: - Initializing data
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    // MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let newCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            // add DoneIt item title to text label of cell
            newCell.textLabel?.text = item.title
            
            // put checkmark if item is done
            // ternary operator
            newCell.accessoryType = item.isDone ? .checkmark : .none
        } else {
            newCell.textLabel?.text = "No items added"
        }
        return newCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }


    // MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Done It item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // after user clicks add item button on UIAlert
            // callback (in the future) after the below has completed
            print("Success!")
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving item, \(error)")
                }
            }
            
            self.tableView.reloadData()

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Methods to manipulate model
    
    // save array of custom items to DB
    // load array of custom items from DB
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        // reload table view
        tableView.reloadData()

    }
    
    // MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    // toggle true/false of isDone property
                    item.isDone = !item.isDone
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

//MARK: - Search bar methods

extension TodoListViewController : UISearchBarDelegate {

    // perform search and reload table view
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            // call default loadItems that returns all of the items
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }


        }

    }

}



