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
    
    func createTask(
        titre: String,
        description: String?,
        adresse: String?,
        cp : String?,
        ville: String?,
        pays: String?,
        completeAdress: String?,
        date: Date,
        isImportant: Bool
    ) {
        let taskToSave = Task(context: context)
        taskToSave.titre = titre
        taskToSave.desc = description
        taskToSave.adresse = adresse
        taskToSave.codePostal = cp
        taskToSave.ville = ville
        taskToSave.pays = pays
        taskToSave.date = date
        taskToSave.isImportant = isImportant
        
        taskToSave.dateCreation = Date.now
        taskToSave.dateModif = Date.now
        
        do {
            try context.save()
        } catch {
            print("Error saving task: \(error)")
        }
    }
        
    func fetchAllTasks() -> [Task] {
        var task = [Task]()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            task = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching tasks: \(error)")
        }
        
        return task
    }
    
    
    func updateTask(
        task: Task,
        newTitre: String,
        newDesc: String,
        newDate: Date,
        newAdresse: String?,
        newCity: String?,
        newCountry: String?,
        newPostalCode: String?,
        newCompleteAdress: String?,
        newImportant: Bool
    ) {
        task.titre = newTitre
        task.desc = newDesc
        task.date = newDate
        task.adresse = newAdresse
        task.ville = newCity
        task.pays = newCountry
        task.codePostal = newPostalCode
        task.completeAdress = newCompleteAdress
        task.isImportant = newImportant
        
        task.dateModif = Date.now
        do {
            try context.save()
        } catch {
            print("Error updating task: \(error)")
        }
    }
    
    func taskIsDone(task: Task) {
        task.isDone = !task.isDone
        do {
            try context.save()
        } catch {
            print("Error terminating task: \(error)")
        }
    }
    
    func deleteTask(task: Task) {
        context.delete(task)
        
        do {
            try context.save()
        } catch {
            print("Error deleting task: \(error)")
        }
    }
}
