//
//  CatagoryViewController.swift
//  Todoey
//
//  Created by Guest on 1/21/19.
//  Copyright © 2019 Guest. All rights reserved.
//

import UIKit
import CoreData

class CatagoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext//SHARED IS AN SINGLETON .WE PULLED CONTEXT OBJ FROM APPDELEGETA FILE
    
    var categoryArray = [Category]() // INITILASIED AS EMPTY ARRAY OF CATEGORYNS OBJ
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//FOR EFFICEINCY WE USE REUSABLECELLS
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {//preparesegue always called before performsegue even if they are written in different places
        
        let destinationVC = segue.destination as! TodolistViewController //to pass data from here to todo list
        
        if   let indexPath = tableView.indexPathForSelectedRow {//there is no selection at the moment
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add a Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a category"
            textField = alertTextField // a reference to alerttextfield once its clicked it holds the value
        }
        alert.addAction(action)
        
        
        present(alert,animated: true,completion: nil)
        
    }
    func saveCategories(){
        
        do{
            try context.save()
        } catch {
            print("Error saving context \(error)")

        }
        tableView.reloadData()
        
    }
    
    func loadCategories (with request : NSFetchRequest<Category>  = Category.fetchRequest()) {
        
        
        do{
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }

    
}

extension CatagoryViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        let sortDiscrotr = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [sortDiscrotr]
        
        loadCategories(with: request)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchBar.text?.count == 0){
            
            loadCategories()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
