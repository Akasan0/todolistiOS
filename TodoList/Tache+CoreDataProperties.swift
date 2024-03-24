//
//  Tache+CoreDataProperties.swift
//  
//
//  Created by tplocal on 23/03/2024.
//
//

import Foundation
import CoreData


extension Tache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tache> {
        return NSFetchRequest<Tache>(entityName: "Tache")
    }

    @NSManaged public var adresse: String?
    @NSManaged public var date: Date?
    @NSManaged public var desc: String?
    @NSManaged public var isImportant: Bool
    @NSManaged public var isTerminated: Bool
    @NSManaged public var titre: String?

}
