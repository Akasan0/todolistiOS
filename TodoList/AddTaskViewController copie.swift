//
//  EntryViewController.swift
//  todolist
//
//  Created by Anaël BARODINE on 13/03/2024.
//

import UIKit

class AddTaskViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var dateEcheance: UIDatePicker!
    @IBOutlet weak var adresse: UITextField!
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var city: UITextField!
    
    
    @IBOutlet weak var isImportant: UISwitch!
    @IBOutlet weak var isImportantButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var update: (() -> Void)?
    
    @IBAction func switchImportant(_ sender: UIButton) {
        isImportant.setOn(!isImportant.isOn, animated: true)
    }
    override func viewDidLoad() {
        print("Add Task has been loaded.")
        
        super.viewDidLoad()
        nameField.delegate = self
        descriptionField.delegate = self
        
    }
    
    @IBAction func saveTask() {
        print("Saving task.")
        
        print(nameField.text ?? "")
        print(descriptionField.text ?? "")
        print(dateEcheance.date)
        print(isImportant.isOn)
        print(adresse.text ?? "")
        print(city.text ?? "")
        print(postalCode.text ?? "")
        if (nameField.text == "") {
            let alertController = UIAlertController(title: "Error", message: "Name field cannot be empty", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return // Exit the function to prevent further execution
        }
        
        let entity = Tache(context: context)
        entity.titre = nameField.text
        entity.desc = descriptionField.text
        entity.adresse = adresse.text
        entity.date = dateEcheance.date
        
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        print("Task saved, popping Add Task view.")
        navigationController?.popViewController(animated: true)
        }
}
