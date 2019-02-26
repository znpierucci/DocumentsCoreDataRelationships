//
//  Document+CoreDataProperties.swift
//  DocumentsCoreDataRelationships
//
//  Created by Zachary Pierucci on 2/26/19.
//  Copyright © 2019 Zachary Pierucci. All rights reserved.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var size: Int64
    @NSManaged public var name: String?
    @NSManaged public var rawDate: NSDate?
    @NSManaged public var content: String?
    @NSManaged public var category: Category?

}
