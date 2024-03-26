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

    @NSManaged public var adresse: String?
    @NSManaged public var codePostal: String?
    @NSManaged public var completeAdress: String?
    @NSManaged public var date: Date?
    @NSManaged public var desc: String?
    @NSManaged public var isImportant: Bool
    @NSManaged public var isDone: Bool
    @NSManaged public var pays: String?
    @NSManaged public var titre: String
    @NSManaged public var ville: String?
    @NSManaged public var dateCreation: Date?
    @NSManaged public var dateModif: Date?

}
