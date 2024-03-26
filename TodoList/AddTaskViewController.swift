//
//  EntryViewController.swift
//  todolist
//
//  Created by Anaël BARODINE on 13/03/2024.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextView!

    @IBOutlet weak var dateEcheance: UIDatePicker!
    
    var outlets: [UIView] = []
    
    @IBOutlet weak var adresse: UITextField!
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var country: UITextField!
    
    var isOK: Bool = true
    
    @IBOutlet weak var adresseButton: UIButton!
    @IBOutlet weak var hasAdress: UISwitch!
    
    
    @IBOutlet weak var isImportant: UISwitch!
    @IBOutlet weak var isImportantButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        print("Add Task has been loaded.")
        
        super.viewDidLoad()
        nameField.delegate = self
        descriptionField.delegate = self

        descriptionField.text = "Description"
        descriptionField.textColor = .placeholderText
        
        descriptionField.layer.borderWidth = 0.5
        descriptionField.layer.borderColor = UIColor.placeholderText.cgColor
        descriptionField.layer.cornerRadius = 5
        
        outlets.append(adresse)
        outlets.append(postalCode)
        outlets.append(city)
        outlets.append(country)
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
        isImportant.setOn(!isImportant.isOn, animated: true)
    }
    
    @IBAction func switchAdress(_ sender: Any) {
        hasAdress.setOn(!hasAdress.isOn, animated: true)
        adressSwitch(sender)
    }
    
    
    @IBAction func adressSwitch(_ sender: Any) {
        UIView.animate(withDuration: 0.6) { [self] in
            outlets.forEach{ (outlet) in outlet.isHidden = !outlet.isHidden
            }
        }
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
            AlertPopupHelper.shared.popupAlert(titre: "Erreur", message: "Le nom de la tache ne peut pas être vide.", viewController: self)
            return
        }
        
        guard let titre = nameField.text else {
            print("Name field vide")
            return
        }
        guard let description = descriptionField.text else {
            print("description vide")
            return
        }
        
        guard let adr = adresse.text else {
            print("adresse vide")
            return
        }
        guard let cp = postalCode.text else {
            print("code postal vide")
            return
        }
        guard let ville = city.text else {
            print("ville vide")
            return
        }
        guard let pays = country.text else {
            print("pays vide")
            return
        }
        
        let completeAdress = adr + ", " + cp +  " " + ville + " " + pays
        
        if (!hasAdress.isOn){
            CoreDataHandler.shared.createTask(
                title: titre,
                description: description,
                date: dateEcheance.date,
                isImportant: isImportant.isOn,
                streetAndNumber: nil,
                postalCode: nil,
                city: nil,
                country: nil
            )
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        GeolocHandler.shared.forwardGeocoding(address: completeAdress) { [self]
            location in
            if let location = location {
                print("location : \(location)")
                
                CoreDataHandler.shared.createTask(
                    title: titre,
                    description: description,
                    date: dateEcheance.date,
                    isImportant: isImportant.isOn,
                    streetAndNumber: adr,
                    postalCode: cp,
                    city: ville,
                    country: pays
                )
                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                AlertPopupHelper.shared.popupAlert(titre: "No location", message: "L'adresse entrée n'est pas valide, veuillez vérifier l'orthographe.", viewController: self)
                isOK = false
            }
        }
    }
}
