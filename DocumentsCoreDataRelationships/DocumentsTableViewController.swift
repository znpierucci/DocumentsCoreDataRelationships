//
//  DocumentsTableViewController.swift
//  DocumentsCoreDataRelationships
//
//  Created by Zachary Pierucci on 2/26/19.
//  Copyright © 2019 Zachary Pierucci. All rights reserved.
//

import UIKit

class DocumentsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var documentsTableView: UITableView!
    
    let dateFormatter = DateFormatter()
    
    var documents = [Document]()
    
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category?.title ?? ""
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //documents = category?.documents?.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as? [Document] ?? [Document]()
        self.documentsTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.documents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        
        if let cell = cell as? DocumentsTableViewCell {
            
            if let doc = category?.documents?[indexPath.row] {
                cell.nameLabel.text = doc.name
                
                let sizeHolder = String(doc.size)
                cell.sizeLabel.text = "Size: " + sizeHolder + " bytes"

                if let formattedDate = doc.date {
                    cell.dateLabel.text = "Modified: " + dateFormatter.string(from: formattedDate)
                } else {
                    cell.dateLabel.text = "Error"
                }
            }
        }
        
        
        return cell
    }
    
    func deleteDocument(at indexPath: IndexPath) {
        guard let document = category?.documents?[indexPath.row],
            let managedContext = document.managedObjectContext else {
                return
        }
        
        managedContext.delete(document)
        
        do {
            try managedContext.save()

            documentsTableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Could not delete document")
            
            documentsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let destination = segue.destination as? DocumentsViewController else {
//            return
//        }
//
//        destination.category = category
        
        if let destination = segue.destination as? DocumentsViewController,
            let segueIdentifier = segue.identifier {
            destination.category = category
            if (segueIdentifier == "editDocument") {
                if let selectedRow = documentsTableView.indexPathForSelectedRow?.row {
                    destination.document = documents[selectedRow]
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteDocument(at: indexPath)
        }
    }
    
    

}
