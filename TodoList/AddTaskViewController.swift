//
//  EntryViewController.swift
//  todolist
//
//  Created by Anaël BARODINE on 13/03/2024.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Éléments UI.
    
    // Titre de la tâche.
    @IBOutlet var taskTitle: UITextField!
    
    // Date d'échéance.
    @IBOutlet weak var taskDate: UIDatePicker!
    
    // Description de la tâche.
    @IBOutlet weak var taskDescription: UITextView!
    
    // Adresse.
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var AddressSwitch: UISwitch!
    @IBOutlet weak var streetAndNumberAddress: UITextField!
    @IBOutlet weak var postalCodeAddress: UITextField!
    @IBOutlet weak var cityAddress: UITextField!
    @IBOutlet weak var countryAddress: UITextField!
    var addressOutlets: [UIView] = []
    
    // Importance
    @IBOutlet weak var importantButton: UISwitch!
    @IBOutlet weak var importantSwitch: UIButton!
    
    // Attributs de view.
    var isOK: Bool = true
    
    override func viewDidLoad() {
        print("Add Task has been loaded.")
        
        super.viewDidLoad()
        taskTitle.delegate = self
        taskDescription.delegate = self
        
        taskDescription.text = "Description"
        taskDescription.textColor = .placeholderText
        
        taskDescription.layer.borderWidth = 0.5
        taskDescription.layer.borderColor = UIColor.placeholderText.cgColor
        taskDescription.layer.cornerRadius = 5
        
        addressOutlets.append(streetAndNumberAddress)
        addressOutlets.append(postalCodeAddress)
        addressOutlets.append(cityAddress)
        addressOutlets.append(countryAddress)
        adressSwitch(self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.placeholderText
        }
    }
    
    @IBAction func switchImportant(_ sender: UIButton) {
        importantButton.setOn(!importantButton.isOn, animated: true)
    }
    
    @IBAction func switchAdress(_ sender: Any) {
        AddressSwitch.setOn(!AddressSwitch.isOn, animated: true)
        adressSwitch(sender)
    }
    
    @IBAction func adressSwitch(_ sender: Any) {
        UIView.animate(withDuration: 0.6) { [self] in
            addressOutlets.forEach{ (outlet) in
                outlet.isHidden = !outlet.isHidden
            }
        }
    }
    
    @IBAction func saveTask() {
        // Vérification de tous les champs.
        // Titre ne doit pas être vide.
        if (taskTitle.text == nil || taskTitle.text == "") {
            AlertPopupHelper.shared.popupAlert(
                titre: "Champ invalide",
                message: "Le titre ne peut être vide.",
                viewController: self
            )
            return
        }
        
        // Description peut être nulle.
        
        // Adresse...
        // Soit les 4 champs sont non nuls, soit ils sont tous nuls.
        if (streetAndNumberAddress.text != "" || postalCodeAddress.text != "" || cityAddress.text != "" || countryAddress.text != "") {
            // Vérification que l'adresse complète est bien valide
            let completeAddress = streetAndNumberAddress.text! + ", " + postalCodeAddress.text! + " " + cityAddress.text! + " " + countryAddress.text!
            GeolocHandler.shared.forwardGeocoding(address: completeAddress) { [self] location in
                print("we are here")
                if let location = location {
                    print("Location : \(location)")
                    CoreDataHandler.shared.createTask(
                        title: taskTitle.text!,
                        description: taskDescription.text,
                        date: taskDate.date,
                        isImportant: importantButton.isOn,
                        streetAndNumber: streetAndNumberAddress.text,
                        postalCode: postalCodeAddress.text,
                        city: cityAddress.text,
                        country: countryAddress.text)
                    
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    AlertPopupHelper.shared.popupAlert(
                        titre: "Localisation introuvable",
                        message: "L'adresse entrée n'est pas valide, veuillez vérifier l'orthographe.",
                        viewController: self
                    )
                    return
                }
            }
        } else {
            CoreDataHandler.shared.createTask(
                title: taskTitle.text!,
                description: taskDescription.text,
                date: taskDate.date,
                isImportant: importantButton.isOn,
                streetAndNumber: streetAndNumberAddress.text,
                postalCode: postalCodeAddress.text,
                city: cityAddress.text,
                country: countryAddress.text)
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                
            }
        }
    }
}
