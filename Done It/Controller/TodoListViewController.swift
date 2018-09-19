//
//  ViewController.swift
//  Done It
//
//  Created by Sydney Beal on 9/18/18.
//  Copyright © 2018 Sydney Beal. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    // var itemArray = ["Book flight", "Schedule haircut", "Complete todo app"]
    var itemArray = [Item]()
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Item()
        newItem.title = "Book flight"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Schedule haircut"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Complete todo app"
        itemArray.append(newItem3)
        
        // defaults
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
 
        
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
        
        // deselect selected cell to un-highlight
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
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
            
            // add to array of items
            self.itemArray.append(newItem)
            
            //save item array to user defaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
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

