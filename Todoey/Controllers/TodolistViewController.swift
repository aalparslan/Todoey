//
//  ViewController.swift
//  Todoey
//
//  Created by Guest on 1/20/19.
//  Copyright © 2019 Guest. All rights reserved.
//

import UIKit

class TodolistViewController: UITableViewController {
    let dataFilePath = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    var itemArray = [Item]() //An array composed of item objects
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    //TableViewDatasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count // Most of the time my data source is an array of something...  will replace with the actual name of the data source
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
            
        cell.textLabel?.text = item.title


        cell.accessoryType = item.done  ? .checkmark : .none
        
        return cell
    }

    //MARK tableviewdelegatemethod
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //it reverses when it is touched
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)// to deselect
    }

    //MARK - add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add neew TOdoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add item button on UIAlert
            let itemobj = Item()
            itemobj.title = textField.text!
            
            self.itemArray.append(itemobj)
            
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField //textfiel is a reference!!!!
        }

        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
        
    }
    
    func saveItems(){
        
        let encoder = PropertyListEncoder() // PropertyListEncoder() clasi turunde encoder objesi yaratildi
        
        
        do{
            let data =  try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            print("error encoding item array \(error)")
        }
        
        
        self.tableView.reloadData()
        
    }
    func loadItems(){
        
        
        if let data = try? Data(contentsOf: dataFilePath!){
            
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data) //decode edip itep arrayi guncelliyor
            } catch {
                
            }
        }
        
    }
    
}

