//
//  Tache+CoreDataProperties.swift
//  
//
//  Created by tplocal on 25/03/2024.
//
//

import Foundation
import CoreData


extension Tache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tache> {
        return NSFetchRequest<Tache>(entityName: "Tache")
    }

    @NSManaged public var adresse: String?
    @NSManaged public var codePostal: String?
    @NSManaged public var completeAdress: String?
    @NSManaged public var date: Date?
    @NSManaged public var desc: String?
    @NSManaged public var isImportant: Bool
    @NSManaged public var isTerminated: Bool
    @NSManaged public var pays: String?
    @NSManaged public var titre: String?
    @NSManaged public var ville: String?
    @NSManaged public var dateCreation: Date?
    @NSManaged public var dateModif: Date?

}
