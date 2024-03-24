//
//  CoreDataHandler.swift
//  TodoList
//
//  Created by tplocal on 23/03/2024.
//

import Foundation
import CoreData
import UIKit

class CoreDataHandler {

    static let shared = CoreDataHandler()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - Create
    
    func createTask(titre: String, description: String, adresse: String, cp : String, ville: String, pays: String, completeAdress: String, date: Date, isImportant: Bool) {
        let tacheToSave = Tache(context: context)
        tacheToSave.titre = titre
        tacheToSave.desc = description
        tacheToSave.adresse = adresse
        tacheToSave.codePostal = cp
        tacheToSave.ville = ville
        tacheToSave.pays = pays
        tacheToSave.date = date
        tacheToSave.isImportant = isImportant
        do {
            try context.save()
        } catch {
            print("Error saving task: \(error)")
        }
    }
    
    // MARK: - Read
    
    func fetchAllTasks() -> [Tache] {
        var tache = [Tache]()
        let fetchRequest: NSFetchRequest<Tache> = Tache.fetchRequest()
        
        do {
            tache = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching tasks: \(error)")
        }
        
        return tache
    }
    
    // MARK: - Update
    
    func updateTask(tache: Tache, newTitre: String, newDesc: String, newDate: Date, newAdresse: String) {
        tache.titre = newTitre
        tache.desc = newDesc
        tache.date = newDate
        tache.adresse = newAdresse
        
        do {
            try context.save()
        } catch {
            print("Error updating task: \(error)")
        }
    }
    
    // MARK: - Delete
    
    func deleteTask(tache: Tache) {
        context.delete(tache)
        
        do {
            try context.save()
        } catch {
            print("Error deleting task: \(error)")
        }
    }
}
