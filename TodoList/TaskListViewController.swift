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
    
    // Éléments UI.
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var sortControl: UISegmentedControl!
    
    // Attributs de view.
    var tasks: [Task] = []
    var refreshController = UIRefreshControl()
    var sortDesc: [NSSortDescriptor] = []
    
    override func viewDidLoad() {
        print("Task List view has been loaded.")
        
        super.viewDidLoad()
        tableView.addSubview(refreshController)
        refreshController.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        updateTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Task List view will appear.")
        updateTasks()
    }
    
    func updateTasks() {
        print("Updating tasks.")
        
        tasks = fetchTasks()
        
        switch (sortControl.selectedSegmentIndex) {
        case 0:
            print("Sort control case 0: sort by importance.")
            importanceSort()
            
        case 1 :
            print("Sort control case 1: sort by date.")
            dateSort()
            
        default :
            print("Default sort control case: sort by importance.")
            importanceSort()
            
        }
        
        print("Reloading table view data.")
        tableView.reloadData()
        
        print("Tasks updating done.")
    }
    
    func fetchTasks() -> [Task] {
        print("Fetching tasks.")
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        //fetchRequest.sortDescriptors = sortDesc
        
        do {
            let tasks = try context.fetch(fetchRequest)
            print("Tasks fetching done.")
            return tasks // Returns the first Task entity, if found
        } catch {
            print("Error fetching Task: \(error)")
            return []
        }
    }
    
    func importanceSort() {
        // Tri d'abord par ordre d'importance.
        tasks.sort{ $0.isImportant && !$1.isImportant }
        // Puis tri sur le caractère terminé ou non.
        tasks.sort{ !$0.isDone && $1.isDone }
    }
    
    func dateSort() {
        // Tri d'abord par date.
        tasks.sort{ $0.date < $1.date }
        // Puis tri sur le caractère terminé ou non.
        tasks.sort{ !$0.isDone && $1.isDone }
    }
    
    @IBAction func sortingControl(_ sender: UISegmentedControl) {
        updateTasks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow,
               let destinationVC = segue.destination as? ViewTaskViewController {
                let selectedTask = tasks[indexPath.row]
                destinationVC.task = selectedTask
            }
        }
    }
    
    @objc func refreshTableView(_ sender: Any){
        updateTasks()
        refreshController.endRefreshing()
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Titre de la cellule.
        let task: Task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        // Sous-titre (label de détail) de la cellule.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd:MM:yyyy HH:mm"
        let dateString = dateFormatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        // Points d'exclamation selon si la tâche est importante.
        if (task.isImportant) {
            cell.imageView?.image = UIImage(systemName: "exclamationmark.2")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        } else {
            cell.imageView?.image = UIImage(systemName: "exclamationmark.2")?.withTintColor(.clear, renderingMode: .alwaysOriginal)
        }
        
        if (task.isDone){
            cell.backgroundColor = .lightGray
        } else {
            cell.backgroundColor = .clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let markAsDone = UIContextualAction(style: .normal, title: "Terminé") { [self] action, view, complete in
            tableView.beginUpdates()
            CoreDataHandler.shared.taskIsDone(task: tasks[indexPath.row])
            tableView.reloadData()
            tableView.endUpdates()
            updateTasks()
            complete(true)
        }
        
        return UISwipeActionsConfiguration(actions: [markAsDone])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let markAsDone = UIContextualAction(style: .destructive, title: "Supprimer") { [self] action, view, complete in
            tableView.beginUpdates()
            CoreDataHandler.shared.deleteTask(task: tasks[indexPath.row])
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
            updateTasks()
            complete(true)
        }
        
        return UISwipeActionsConfiguration(actions: [markAsDone])
    }
}

extension UserDefaults {
    enum Keys {
        static let showDoneTask = "showDoneTask"
    }
}

