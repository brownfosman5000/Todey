//
//  ViewController.swift
//  Todey
//
//  Created by Foster Brown on 3/8/18.
//  Copyright © 2018 Foster Brown. All rights reserved.
//

import UIKit
import RealmSwift

class TodoeyTableViewController: UITableViewController {

    let realm = try! Realm()
    var toDoListItems: Results<Item>?
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - DataSource Methods
    //Populate table with cell title and checkmark if provided
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoListItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No items added"
        }

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoListItems?.count ?? 1
    }
    
    
    //MARK: - Delegate Methods
    // Perform operations on whichever row was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        do{
            try realm.write {
                if let item = toDoListItems?[indexPath.row]{
                    item.done = !item.done
                }
            }
        }catch{
            print("Error toggling checkmark \(error)")
        }

        tableView.reloadData()
    }
    
    
    //MARK: - Add Button Functionality
    @IBAction func addAnItem(_ sender: Any) {

        let alert = UIAlertController(title: "Add an Item to the List", message: nil, preferredStyle: .alert)
        var gtextField = UITextField()


        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            let newItem = Item()
            
            do{
                try self.realm.write {
                    newItem.title = gtextField.text!
                    newItem.dateCreated = Date()
                    self.selectedCategory?.items.append(newItem)
                    self.realm.add(newItem)
                }
            }catch{
                print("Error writing to Realm Database \(error)")
            }
            
            self.tableView.reloadData()

        }
        alert.addTextField { (textField) in
            gtextField = textField
            gtextField.placeholder = "Create a new item"

        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
    //Load items from the database
    func loadItems(){
        toDoListItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    

}

extension TodoeyTableViewController : UISearchBarDelegate{

    //When search button clicked search and sort the results in an ascending order
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoListItems = toDoListItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
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

