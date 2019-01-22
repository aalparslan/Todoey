//
//  ViewController.swift
//  Todoey
//
//  Created by Guest on 1/20/19.
//  Copyright © 2019 Guest. All rights reserved.
//

import UIKit
import RealmSwift

class TodolistViewController: UITableViewController {

    var todoItems: Results<Item>?
    
    let realm = try! Realm()

    var selectedCategory : Category? {
        
        didSet{//EVERYTHING BETWEEN THESE CURLY BRACES IS GONNA HAPPEN AS SOON AS selectedCategory loaded with a value.
            loadItems()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print(FileManager.default.urls(for:.documentDirectory, in: .userDomainMask))
        
        
     }
    
    //TableViewDatasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1// Most of the time my data source is an array of something...  will replace with the actual name of the data source
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            
            cell.accessoryType = item.done  ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }

    //MARK tableviewdelegatemethod
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write { //realm.write updates database in the run time
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)// to deselect
    }

    //MARK - add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add neew TOdoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add item button on UIAlert
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        
                    }
                } catch {
                    print("Error saving items \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField //textfield is a reference!!!!
        }

        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
        
    }
    
//    func saveItems(item : Item){
//
//        do{
//         try realm.write {
//                realm.add(item)
//            }
//        } catch {
//            print("Error saving context \(error)")
//
//        }
//
//        self.tableView.reloadData()
//
//    }
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
 
}


//MARK: - Search Bar Methods
extension TodolistViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending:true)
        tableView.reloadData()
        
    }


        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchBar.text?.count == 0 ){
            
            loadItems()
            
            
            DispatchQueue.main.async { //Donmayi engeller
                searchBar.resignFirstResponder() // SO SEARCHBAR IS NO LONGER GOING TO BE  THE SELECTED
            }
        }
    }

    
}

