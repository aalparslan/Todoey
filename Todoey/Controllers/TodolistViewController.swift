//
//  ViewController.swift
//  Todoey
//
//  Created by Guest on 1/20/19.
//  Copyright © 2019 Guest. All rights reserved.
//

import UIKit
import CoreData
class TodolistViewController: UITableViewController {

    var itemArray = [Item]() //An array composed of item objects
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // REACHED TO PERSISTENTCONTAINER (DATABASE) BY CREATING A APPDELEGATE OBJ
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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
      
        
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done //it reverses when it is touched
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)// to deselect
    }

    //MARK - add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add neew TOdoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add item button on UIAlert
            
            
            let itemobj = Item(context: self.context) //PLACE THAT YOU SAVE ITEMOBJ TO THE PASSING AREA CALLED CONTEXT,CAREFUL YOU DIDNOT SAVE IT TO THE COREDATA YET!
            
            itemobj.title = textField.text!
            itemobj.done = false
            itemobj.parentCategory = self.selectedCategory
            self.itemArray.append(itemobj)
            
            
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField //textfield is a reference!!!!
        }

        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
        
    }
    
    func saveItems(){
        
        
        
        do{
            try context.save()//COMMAND FORE SAVING EVERYTHING IN THE CONTEXT TO THE COREDATA
        } catch {
            print("Error saving context \(error)")
        }
        
        
        self.tableView.reloadData()
        
    }
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil ){//READ //external and internal paramerters ,eger parametresiz cagirilirsa load items default value yu yani ite.fetchRequest i kullanacak,parametreli caligirilirsa  ornegin searchbar da specify edilmis sekliyle query edilirse query edilen elementleri databaseden fetch eder
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        request.predicate = compoundPredicate
        }else{
            request.predicate = categoryPredicate
        }
        do{
        itemArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
}


//MARK: - Search Bar Methods
extension TodolistViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //GOOD POINT TO QUERY OUR DATA
        let request : NSFetchRequest<Item> = Item.fetchRequest() //TO READ USE THIS ALWAYS
        
        //TO QUERY DATA WE NEED TO USE NS PREDICATE
        let  predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)//WE HAVE STRUCTURED OUR QUERY
        
        let sortDecriptor = NSSortDescriptor(key: "title", ascending: true)//ALFABETIK SIRALAR
        
        request.sortDescriptors = [sortDecriptor] //ASLINDA MAVI METOD ARRAY OF NSSORTDESCRIPTORS BEKLIYOR
        
        loadItems(with: request, predicate: predicate )

        
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

