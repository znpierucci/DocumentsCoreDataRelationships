//
//  Category+CoreDataClass.swift
//  DocumentsCoreDataRelationships
//
//  Created by Zachary Pierucci on 2/26/19.
//  Copyright © 2019 Zachary Pierucci. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Category)
public class Category: NSManagedObject {

    var documents: [Document]? {
        return self.rawDocuments?.array as? [Document]
    }
    
    convenience init? (title: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext
        else {
            return nil
        }
        
        self.init(entity: Category.entity(), insertInto: managedContext)
        
        self.title = title
    }
}
