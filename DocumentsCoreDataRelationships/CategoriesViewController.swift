//
//  CategoriesViewController.swift
//  DocumentsCoreDataRelationships
//
//  Created by Zachary Pierucci on 2/26/19.
//  Copyright © 2019 Zachary Pierucci. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveCategory(_ sender: UIBarButtonItem) {
        let title = titleField.text
        let category = Category(title: title ?? "")
        
        do {
            try category?.managedObjectContext?.save()
            
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Could not save category")
        }
    }
    
}
