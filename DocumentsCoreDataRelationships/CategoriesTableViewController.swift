//
//  CategoriesTableViewController.swift
//  DocumentsCoreDataRelationships
//
//  Created by Zachary Pierucci on 2/26/19.
//  Copyright © 2019 Zachary Pierucci. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            categories = try managedContext.fetch(fetchRequest)
            
            categoriesTableView.reloadData()
        } catch {
            print("Could not fetch category")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        if let cell = cell as? CategoriesTableViewCell {
            let cat = categories[indexPath.row]
            cell.titleLabel.text = cat.title
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DocumentsTableViewController,
            let selectedRow = self.categoriesTableView.indexPathForSelectedRow?.row else {
                return
        }
        
        destination.category = categories[selectedRow]
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        guard let managedContext = category.managedObjectContext else {
            return
        }
        
        managedContext.delete(category)
        
        do {
            try managedContext.save()
            
            categories.remove(at: indexPath.row)
            
            categoriesTableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Could not delete category")
            
            categoriesTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func deleteCategoryConfirmation(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        if let documents = category.documents, documents.count > 0 {
            
            let name = category.title ?? "This category"
            
            let alert = UIAlertController(title: "Delete Category?", message: "\(name) contains documents inside. Are you sure you want to delete it?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                (alertAction) -> Void in
                self.categoriesTableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: {
                (alertAction) -> Void in
                self.deleteCategory(at: indexPath)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            deleteCategory(at: indexPath)
        }
    }
    
    func editCategory(at indexPath: IndexPath){
        let category = categories[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            action, index in
            self.deleteCategoryConfirmation(at: indexPath)
        }
        
        let edit = UITableViewRowAction(style: .default, title: "edit") {
            action, index in
            self.editCategory(at: indexPath)
        }
        edit.backgroundColor = UIColor.gray
        
        return [delete, edit]
    }
    
}
