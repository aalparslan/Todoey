//
//  ViewController.swift
//  Todoey
//
//  Created by Guest on 1/20/19.
//  Copyright © 2019 Guest. All rights reserved.
//

import UIKit

class TodolistViewController: UITableViewController {

    var itemArray = ["Find Mike","Buy Eggs","Destroy DEmogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //TableViewDatasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count // Most of the time my data source is an array of something...  will replace with the actual name of the data source
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }

    //MARK tableviewdelegatemethod
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
    
        let reference = tableView.cellForRow(at: indexPath)
        
        if(reference?.accessoryType == .checkmark){
            reference?.accessoryType = .none
        }else{
            reference?.accessoryType = .checkmark
        }
       
        //REFERENCE TO CELL TO THE CELL ->> tableView.cellForRow(at: indexPath)
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)// to deselect
        
        
    }

    //MARK - add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add neew TOdoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add item button on UIAlert
            self.itemArray.append(textField.text! )
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
        
    }
    
}

