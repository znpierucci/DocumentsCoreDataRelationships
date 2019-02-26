//
//  DocumentsViewController.swift
//  DocumentsCoreDataRelationships
//
//  Created by Zachary Pierucci on 2/26/19.
//  Copyright © 2019 Zachary Pierucci. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var contentView: UITextView!
    
    var category: Category?
    
    var document: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let document = document {
            let name = document.name
            nameField.text = name
            contentView.text = document.content
            title = name
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func nameChanged(_ sender: Any) {
        title = nameField.text
        
    }
    
    @IBAction func saveDocument(_ sender: UIBarButtonItem) {
        guard let name = nameField.text else {
            print("Error - Name 1")
            return
        }
        
        let documentName = name.trimmingCharacters(in: .whitespaces)
        if (documentName == "") {
            print("Error - Name 2")
        }
        
        let content = contentView.text
        
        if document == nil {
            document = Document(name: documentName, content: content)
        } else {
            document?.update(name: documentName, content: content)
        }
        
        if let document = Document(name: name, content: content){
            category?.addToRawDocuments(document)
            
            do {
                try document.managedObjectContext?.save()
                
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Document could not be created")
            }
        }
    }
    
}
