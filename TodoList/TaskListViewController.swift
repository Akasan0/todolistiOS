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
    @IBOutlet weak var sortControl: UISegmentedControl!
    
    var taches: [Tache] = []
    var refreshController = UIRefreshControl()
    var sortDesc: [NSSortDescriptor] = []
    
    func fetchtasks() ->[Tache] {
        let fetchRequest: NSFetchRequest<Tache> = Tache.fetchRequest()
        //fetchRequest.sortDescriptors = sortDesc
        print(sortDesc)
        do {
            var tasks = try context.fetch(fetchRequest)
            tasks.forEach{ tache in print(tache.isImportant)}
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
        updateTasks()
        // Setup
    }
    
    func triNormal(){
        taches.sort{ $0.isImportant && !$1.isImportant}
        //taches.sort{ $0.dateModif! < $1.dateModif!}
        taches.sort{ !$0.isTerminated && $1.isTerminated}
    }
    
    func triDateEch(){
        taches.sort{ $0.date! < $1.date!}
        taches.sort{ !$0.isTerminated && $1.isTerminated}
    }
    
    @IBAction func sortingControl(_ sender: UISegmentedControl) {
        updateTasks()
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
        switch (sortControl.selectedSegmentIndex){
        case 0:
            print("0")
            triNormal()
        case 1 :
            print("1")
            triDateEch()
        default :
            print("default")
            triNormal()
        }
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
        
        if (tache.isTerminated){
            cell.backgroundColor = .lightGray
        } else {
            cell.backgroundColor = .clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let modify = UIContextualAction(style: .normal, title: "Modify") { [self] action, view, complete in
            print("Modify")
            tableView.beginUpdates()
            CoreDataHandler.shared.tacheIsDone(tache: taches[indexPath.row])
            taches = fetchtasks()
            tableView.reloadData()
            tableView.endUpdates()
            complete(true)
            
        }
        
        return UISwipeActionsConfiguration(actions: [modify])
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

extension UserDefaults {
    enum Keys {
        static let showDoneTask = "showDoneTask"
    }
}

