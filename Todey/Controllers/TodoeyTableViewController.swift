//
//  ViewController.swift
//  Todey
//
//  Created by Foster Brown on 3/8/18.
//  Copyright © 2018 Foster Brown. All rights reserved.
//

import UIKit

class TodoeyTableViewController: UITableViewController {

    var items = [Item]()
    let defaults = UserDefaults.standard
    let itemsFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent("Items.plist")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
        
//        if let itemArray = defaults.array(forKey: "TodeyList") as? [Item]{
//            items = itemArray
//        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - DataSource Methods
    
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
            print("Success")
            
            let newItem = Item()
            
            newItem.itemName = gtextField.text!
            self.items.append(newItem)
            
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
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.items)
            try data.write(to: self.itemsFilePath!)
        }
        catch{
            print("Problem encoding data: \(error)")
        }
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: itemsFilePath!){
            let decoder = PropertyListDecoder()
            do{
                items = try decoder.decode([Item].self, from: data)
                
            }
            catch{
                print("Failed to decode: \(error)")
            }
        }

    }
    

}

