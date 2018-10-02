//
//  SwipeTableViewController.swift
//  Done It
//
//  Created by Sydney Beal on 9/30/18.
//  Copyright © 2018 Sydney Beal. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70.0
    }
    
    // MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
        
    }

    // MARK: - Swipe cell delegate methods
        
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
            
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
        
            // handle action by updating model with deletion
            
            // print("cell deleted")
            
            self.updateModel(at: indexPath)
            

            
                //tableView.reloadData()
 //           }
                
        }
            
            // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
            
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // update data model
    }
        
}

