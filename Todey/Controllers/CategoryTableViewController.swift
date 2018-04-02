//
//  CategoryTableViewController.swift
//  Todey
//
//  Created by Foster Brown on 4/1/18.
//  Copyright © 2018 Foster Brown. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    
    
    //Deselect item as in make that grey highlight disappear
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeyTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    //Add button creates an alert that gives the user a chance to add a category
    @IBAction func addACategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a Category", message: nil, preferredStyle: .alert)
        
        
        
        let action = UIAlertAction(title: "Add a Category", style: .default) { (action) in
            print(textField.text!)
            let newCategory = Category()
            
            newCategory.name = textField.text!
            self.save(category: newCategory)

        }
        
        alert.addTextField { (gtextField) in
            textField = gtextField
            textField.placeholder = "Create a new category..."
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category )
            }
        }catch{
            print("Error saving context: \(error)")
        }
        
        self.tableView.reloadData()
    
    }
    
    func load(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
}
