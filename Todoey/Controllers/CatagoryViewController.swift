//
//  CatagoryViewController.swift
//  Todoey
//
//  Created by Guest on 1/21/19.
//  Copyright © 2019 Guest. All rights reserved.
//

import UIKit
import RealmSwift

class CatagoryViewController: UITableViewController {
    
    let realm = try! Realm() //new realmdatabase created

    
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//FOR EFFICEINCY WE USE REUSABLECELLS
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added"
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {//preparesegue always called before performsegue even if they are written in different places
        
        let destinationVC = segue.destination as! TodolistViewController //to pass data from here to todo list
        
        if   let indexPath = tableView.indexPathForSelectedRow {//there is no selection at the moment
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()  
            
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a category"
            textField = alertTextField // a reference to alerttextfield once its clicked it holds the value
        }
        alert.addAction(action)
        
        
        present(alert,animated: true,completion: nil)
        
    }
    func save(category : Category){
        
        do{
            try realm.write {//do update database commit!
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")

        }
        tableView.reloadData()
        
    }
    
    func loadCategories () {
        categoryArray = realm.objects(Category.self)//READS FROM REALM
         tableView.reloadData()
    }

    
}

//extension CatagoryViewController : UISearchBarDelegate{
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        
//        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
//        
//        let sortDiscrotr = NSSortDescriptor(key: "name", ascending: true)
//        
//        request.sortDescriptors = [sortDiscrotr]
//        
//        loadCategories(with: request)
//    }
//    
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        if(searchBar.text?.count == 0){
//            
//            loadCategories()
//            
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//    
//}
