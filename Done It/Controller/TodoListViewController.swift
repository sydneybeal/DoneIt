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

    /* Previous testing with data stored in file system:
     // access app files and create path to new .plist for Done It items
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
     
     // String array and user defaults
     var itemArray = ["Book flight", "Schedule haircut", "Complete todo app"]
     var defaults = UserDefaults.standard
    */
    
    // MARK: - Initializing data
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        /* test adding items
        let newItem = Item()
        newItem.title = "Book flight"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Schedule haircut"
        itemArray.append(newItem2)
        */

        
        /* using user defaults
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        */
        

        
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

    // MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        // reverse true/false of isDone property
//        todoItems[indexPath.row].isDone = !todoItems[indexPath.row].isDone
//
//        // update true/false status in Items.plist
//        saveItems()
        
        // deselect selected cell to un-highlight
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Done It item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // after user clicks add item button on UIAlert
            // callback (in the future) after the below has completed
            print("Success!")
            
            
            
//            // create new item with title
//
//            let newItem = Item(context: self.context)
//            newItem.title =  textField.text!
//            newItem.isDone = false
//            newItem.parentCategory = self.selectedCategory
//
//            // add to array of items, save, update tableView
//            self.itemArray.append(newItem)
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving realm, \(error)")
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


}

//MARK: - Search bar methods

//extension TodoListViewController : UISearchBarDelegate {
//
//    // perform search and reload table view
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        // initialize fetch request
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        // set up predicate and sorting
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        // retrieve itemArray of search results
//        loadItems(with: request, predicate: predicate)
//
////        do {
////            itemArray = try context.fetch(request)
////        } catch {
////            print("Error fetching data from context, \(error)")
////        }
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            // call default loadItems that returns all of the items
//            loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//
//        }
//
//    }
//
//}



