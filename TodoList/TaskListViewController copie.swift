//
//  ViewController.swift
//  todolist
//
//  Created by tplocal on 27/02/2024.
//

import UIKit

class TaskListViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        print("Task List view has been loaded.")
        
        super.viewDidLoad()
        //tableView.delegate = self
        //tableView.dataSource = self
        
        // Setup
        if true || !UserDefaults().bool(forKey: "setup") {
            print("UserDefaults is not setup.")
            
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
            UserDefaults().set(0, forKey: "nextId")
        } else {
            print("UserDefaults is setup.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Task List view will appear.")
        
        updateTasks()
    }
    
    func updateTasks() {
        print("Updating tasks.")
        
    
    }
}

/*extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.endUpdates()
    }
 
}
*/
