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
        title: String,
        description: String?,
        date: Date,
        isImportant: Bool,
        streetAndNumber: String?,
        postalCode : String?,
        city: String?,
        country: String?
    ) {
        let taskToSave = Task(context: context)
        taskToSave.title = title
        taskToSave.desc = description
        taskToSave.streetAndNumber = streetAndNumber
        taskToSave.postalCode = postalCode
        taskToSave.city = city
        taskToSave.country = country
        taskToSave.date = date
        taskToSave.isImportant = isImportant
        
        taskToSave.creationDate = Date.now
        taskToSave.editionDate = Date.now
        
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
        newTitle: String,
        newDescription: String?,
        newDate: Date,
        newIsImportant: Bool,
        newStreetAndNumber: String?,
        newCity: String?,
        newCountry: String?,
        newPostalCode: String?
    ) {
        task.title = newTitle
        task.desc = newDescription
        task.date = newDate
        task.isImportant = newIsImportant
        task.streetAndNumber = newStreetAndNumber
        task.postalCode = newPostalCode
        task.city = newCity
        task.country = newCountry
        
        task.editionDate = Date.now
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
