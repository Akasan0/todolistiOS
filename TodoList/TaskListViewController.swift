//
//  ViewController.swift
//  todolist
//
//  Created by tplocal on 27/02/2024.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController  {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var tableView: UITableView!
    var taches: [Tache] = []
    var refreshController = UIRefreshControl()
    
    func fetchtasks() ->[Tache] {
        let triNormal : NSSortDescriptor = NSSortDescriptor(key: "isImportant", ascending: false)
        let fetchRequest: NSFetchRequest<Tache> = Tache.fetchRequest()
        fetchRequest.sortDescriptors = [triNormal]
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks // Returns the first Task entity, if found
        } catch {
            print("Error fetching Task: \(error)")
            return []
        }
    }
    
    override func viewDidLoad() {
        print("Task List view has been loaded.")
        
        super.viewDidLoad()
        tableView.addSubview(refreshController)
        refreshController.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        taches = fetchtasks()
        // Setup
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow,
               let destinationVC = segue.destination as? ViewTaskViewController {
                let selectedTask = taches[indexPath.row]
                destinationVC.tache = selectedTask
            }
        }
    }
    
    
    @objc func refreshTableView(_ sender: Any){
        updateTasks()
        refreshController.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Task List view will appear.")
        updateTasks()
    }
    
    func updateTasks() {
        taches = fetchtasks()
        tableView.reloadData()
        print("Updating tasks.")
    }
    
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let tache: Tache = taches[indexPath.row]
        cell.textLabel?.text = tache.titre
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd:MM:yyyy HH:mm"
        let dateString = dateFormatter.string(from: tache.date!)
        
        cell.detailTextLabel?.text = dateString
        
        if (tache.isImportant){
            cell.imageView?.image = UIImage(systemName: "exclamationmark.2")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        } else {
            cell.imageView?.image = UIImage(systemName: "exclamationmark.2")?.withTintColor(.clear, renderingMode: .alwaysOriginal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        CoreDataHandler.shared.deleteTask(tache: taches[indexPath.row])
        taches.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.endUpdates()
    }
    
}

