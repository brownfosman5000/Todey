//
//  CategoryTableViewController.swift
//  Todey
//
//  Created by Foster Brown on 4/1/18.
//  Copyright © 2018 Foster Brown. All rights reserved.
//

import UIKit
import CoreData
class CategoryTableViewController: UITableViewController {

    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContext()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = categories[indexPath.row].name!

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    
    //Deselect item as in make that grey highlight disappear
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeyTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    //Add button creates an alert that gives the user a chance to add a category
    @IBAction func addACategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a Category", message: nil, preferredStyle: .alert)
        
        
        
        let action = UIAlertAction(title: "Add a Category", style: .default) { (action) in
            print(textField.text!)
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveContext()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (gtextField) in
            textField = gtextField
            textField.placeholder = "Create a new category..."
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveContext(){
        do{
            try context.save()
        }catch{
            print("Error saving context: \(error)")
        }
    
    }
    
    func loadContext(){
        let request: NSFetchRequest<Category> = NSFetchRequest.init(entityName: "Category")
        do{
            categories = try context.fetch(request)
            print(categories)
        }catch{
            print("Error loading context: \(error)")
        }
    }
    
    
}
