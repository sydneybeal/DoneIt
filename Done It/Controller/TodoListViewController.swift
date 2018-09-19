//
//  ViewController.swift
//  Done It
//
//  Created by Sydney Beal on 9/18/18.
//  Copyright © 2018 Sydney Beal. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    // MARK: - Global constants
    
    // array of Done It items
    var itemArray = [Item]()
    
    // access app files and create path to new .plist for Done It items
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    /* Previous testing with String array and user defaults:
     var itemArray = ["Book flight", "Schedule haircut", "Complete todo app"]
     var defaults = UserDefaults.standard
    */
    
    // MARK: - Initializing data
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // print(dataFilePath)
        
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
        
        
        // using NSCoder
        loadItems()
        
    }
    
    // MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let newCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        // add DoneIt item title to text label of cell
        newCell.textLabel?.text = item.title
        
        // put checkmark if item is done
        // ternary operator
        newCell.accessoryType = item.isDone ? .checkmark : .none
        
        return newCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    // MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        // reverse true/false of isDone property
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        
        // update true/false status in Items.plist
        saveItems()
        
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
            
            // create new item with title
            let newItem = Item()
            newItem.title =  textField.text!
            
            // add to array of items, save, update tableView
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Methods to manipulate model
    
    // encode array of custom objects
    func saveItems() {
        // old version - save String array to user defaults
        // self.defaults.set(self.itemArray, forKey: "TodoListArray")
        
        // new version - save Item array to new .plist in documents
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding array, \(error)")
        }
        
        // refresh tableView data on screen
        tableView.reloadData()
    }
    
    // decode array of custom objects
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding array, \(error)")
            }
        }
    }

}

