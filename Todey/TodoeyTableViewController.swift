//
//  ViewController.swift
//  Todey
//
//  Created by Foster Brown on 3/8/18.
//  Copyright © 2018 Foster Brown. All rights reserved.
//

import UIKit

class TodoeyTableViewController: UITableViewController {

    var items = ["Get Milk","Get Eggs","Get Ham"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.item]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    //MARK: - Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.item])
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
    
    //MARK: - Add Button Functionality
    @IBAction func addAnItem(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add an Item to the List", message: nil, preferredStyle: .alert)
        var gtextField = UITextField()
        
  
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Success")
            print(gtextField.text!)
            self.items.append(gtextField.text!)
            self.tableView.reloadData()
     
        }
        alert.addTextField { (textField) in
            gtextField = textField
            gtextField.placeholder = "Create a new item"
            
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

