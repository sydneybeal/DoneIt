//
//  CategoryViewController.swift
//  Done It
//
//  Created by Sydney Beal on 9/21/18.
//  Copyright © 2018 Sydney Beal. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var catArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    
    //MARK: - Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let newCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = catArray[indexPath.row]
        
        newCell.textLabel?.text = category.name
        
        return newCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray.count
    }
    
    //MARK: - Data manipulation methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving data to context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            catArray = try context.fetch(request)
        } catch {
            print("Error loading data from context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Done It Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.catArray.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

    
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // only one segue, not needed if statement (if segue identifier == "goToItems")
        let destinationVC = segue.destination as! TodoListViewController
        // grab category from selected cell
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catArray[indexPath.row]
        }
        
        
    }
    
    
    
    
    
    
    
    
}
