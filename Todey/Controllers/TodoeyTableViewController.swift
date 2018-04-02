//
//  ViewController.swift
//  Todey
//
//  Created by Foster Brown on 3/8/18.
//  Copyright © 2018 Foster Brown. All rights reserved.
//

import UIKit
import CoreData

class TodoeyTableViewController: UITableViewController {

    var items = [Item]()
    //let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - DataSource Methods
    //Populate table with cell title and checkmark if provided
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = items[indexPath.row].itemName
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    //MARK: - Delegate Methods
    // Perform operations on whichever row was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        items[indexPath.row].done = !items[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
    
    //MARK: - Add Button Functionality
    @IBAction func addAnItem(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add an Item to the List", message: nil, preferredStyle: .alert)
        var gtextField = UITextField()
        
  
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            
            newItem.itemName = gtextField.text!
            self.items.append(newItem)
            newItem.parentCategory = self.selectedCategory
            self.tableView.reloadData()
            
            self.saveItems()
            
            //self.defaults.set(self.items, forKey: "TodeyList")
        }
        alert.addTextField { (textField) in
            gtextField = textField
            gtextField.placeholder = "Create a new item"
            
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Save items in a database core data
    func saveItems(){
        do{
            try context.save()
        }
        catch{
            print("Saving Error: \(error)")
        
        }
    }
    
    //Load items from the database
    func loadItems(with request: NSFetchRequest<Item> = NSFetchRequest.init(entityName: "Item")){
        print(selectedCategory!.name!)
        request.predicate = NSPredicate.init(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        do{
            items = try context.fetch(request)
            print(items)
        }catch{
            print("Error loading database \(error) ")
        }
        tableView.reloadData()
    }
    
    

}

extension TodoeyTableViewController : UISearchBarDelegate{
    
    //When search button clicked search and sort the results in an ascending order
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = NSFetchRequest.init(entityName: "Item")
        
        request.predicate = NSPredicate.init(format: "itemName CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor.init(key: "itemName", ascending: true)]

        loadItems(with: request)
        
        tableView.reloadData()
    }
    
    //When text is null after search then load the items in and close keyboard
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

