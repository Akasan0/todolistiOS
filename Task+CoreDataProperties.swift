//
//  Tache+CoreDataProperties.swift
//  
//
//  Created by tplocal on 25/03/2024.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }
    
    @NSManaged public var title: String
    @NSManaged public var desc: String?
    @NSManaged public var date: Date
    @NSManaged public var isImportant: Bool
    @NSManaged public var streetAndNumber: String?
    @NSManaged public var city: String?
    @NSManaged public var postalCode: String?
    @NSManaged public var country: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var creationDate: Date
    @NSManaged public var editionDate: Date

}
