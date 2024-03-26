//
//  TaskViewController.swift
//  todolist
//
//  Created by Anaël BARODINE on 13/03/2024.
//

import UIKit
import MapKit

class ViewTaskViewController: UIViewController, UITextViewDelegate {
    // Éléments UI.
    
    // Crayon "éditer" en haut à droite.
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // Titre de la tâche.
    @IBOutlet weak var taskTitle: UITextField!
    
    // Description de la tâche.
    @IBOutlet weak var taskDescription: UITextView!
    
    // Importance.
    @IBOutlet weak var importantButton: UIButton! // Texte "Tâche importante" qui est un bouton.
    @IBOutlet weak var importantSwitch: UISwitch! // Switch tâche importante.
    
    // Séparateur 1 (entre importance et date d'échéance).
    @IBOutlet weak var separator1: UILabel!
    
    // Date d'échéance.
    @IBOutlet weak var dueDate: UIDatePicker!
    
    // Séparateur 2 (entre date d'échéance et adresse).
    @IBOutlet weak var separator2: UILabel!
    
    // Adresse.
    @IBOutlet weak var addressButton: UIButton! // Texte "Ajouter/modifier adresse" qui est un bouton.
    @IBOutlet weak var addressSwitch: UISwitch! // Switch ajout ou modification d'adresse.
    @IBOutlet weak var streetAndNumberAddress: UITextField!
    @IBOutlet weak var postalCodeAddress: UITextField!
    @IBOutlet weak var cityAddress: UITextField!
    @IBOutlet weak var countryAddress: UITextField!
    var addressOutlets: [UIView] = []
    
    // Plan.
    @IBOutlet weak var mapView: MKMapView!
    
    // Boutons de confirmation ou d'annulation.
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelOrConfirmButtons: UIStackView!
    
    // Attributs de view.
    var editMode: Bool = false
    var isOkToEdit : Bool = true
    var task: Task?
    
    override func viewDidLoad() {
        print("View Task has been loaded.")
        
        super.viewDidLoad()
        taskDescription.heightAnchor.constraint(equalToConstant: taskDescription.contentSize.height).isActive = true
        reloadView()
    }
    
    func reloadView(){
        UIView.animate(withDuration: 0.5) { [self] in
            // Titre.
            taskTitle.text = task?.titre
            taskTitle.isEnabled = false
            
            // Description.
            taskDescription.text = task?.desc
            taskDescription.isEditable = false
            // Contrainte pour que la hauteur corresponde au texte saisi.
            //descriptionView.heightAnchor.constraint(equalToConstant: descriptionView.contentSize.height).isActive = true
            taskDescription.layer.borderWidth = 0
            taskDescription.delegate = self
            
            // Boutons et switch d'importance.
            importantButton.isHidden = true
            importantSwitch.isHidden = true
            importantSwitch.isOn = task?.isImportant ?? false
            
            // Séparateur 1.
            separator1.backgroundColor = UIColor.black
            separator1.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            // Date d'échéance.
            dueDate.date = (task?.date)!
            dueDate.isEnabled = false
            
            // Séparateur 2.
            separator2.backgroundColor = UIColor.black // Example separator color
            separator2.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            // Boutons et switch d'adresse.
            addressButton.isHidden = true
            addressSwitch.isHidden = true
            
            // Adresse.
            addressOutlets.append(streetAndNumberAddress)
            streetAndNumberAddress.text = task?.adresse
            addressOutlets.append(postalCodeAddress)
            postalCodeAddress.text = task?.codePostal
            addressOutlets.append(cityAddress)
            cityAddress.text = task?.ville
            addressOutlets.append(countryAddress)
            countryAddress.text = task?.pays
            
            UIView.animate(withDuration: 0.6) { [self] in
                addressOutlets.forEach { outlet in
                    outlet.isHidden = true
                }
            }
            
            // Boutons du bas.
            cancelOrConfirmButtons.isHidden = true
            cancelButton.tintColor = .red
            
            // Plan.
            if (!isAddressGiven()) {
                mapView.isHidden = true
            } else {
                mapView.isHidden = false
                GeolocHandler.shared.forwardGeocoding(address: (task?.adresse)!) { [self] location in
                    if let location = location {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location.coordinate
                        annotation.title = task?.titre
                        annotation.subtitle = task?.adresse
                        let regionRadius: CLLocationDistance = 1000
                        let coordinateRegion = MKCoordinateRegion(
                            center: location.coordinate,
                            latitudinalMeters: regionRadius * 2.0,
                            longitudinalMeters: regionRadius * 2.0
                        )
                        mapView.setRegion(coordinateRegion, animated: true)
                        mapView.addAnnotation(annotation)
                    }
                }
            }
        }
    }
    
    func isAddressGiven() -> Bool {
        if (task?.adresse == nil || task?.codePostal == nil || task?.ville == nil || task?.pays == nil) {
            return false
        } else if (task?.adresse == "" || task?.codePostal == "" || task?.ville == "" || task?.pays == "") {
            return false
        }
        
        return true
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        if (editMode) {
            // Désactivation du mode édition, reload de la vue (car par défaut en non édition).
            reloadView()
            editMode = false
        } else {
            // Activation du mode édition.
            goToEditMode()
            editMode = true
        }
    }
    
    func goToEditMode() {
        UIView.animate(withDuration: 0.6) { [self] in
            // Titre.
            taskTitle.isEnabled = true
            
            // Description.
            taskDescription.isEditable = !taskDescription.isEditable
            taskDescription.layer.borderWidth = 0.5
            taskDescription.layer.borderColor = UIColor.placeholderText.cgColor
            taskDescription.layer.cornerRadius = 5
            
            // Importance.
            importantButton.isHidden = false
            importantSwitch.isHidden = false
            
            // Échéance.
            dueDate.isEnabled = true
            
            // Adresse.
            addressButton.isHidden = false
            addressSwitch.isHidden = false
            
            // Boutons du bas.
            cancelOrConfirmButtons.isHidden = false
            
            // Plan.
            mapView.isHidden = true
        }
    }
    
    @IBAction func switchImportant(_ sender: Any) {
        importantSwitch.isOn = !importantSwitch.isOn
    }
    
    @IBAction func addAddressButton(_ sender: Any) {
        addressSwitch.isOn = !addressSwitch.isOn
        addAddressAppear()
    }
    
    @IBAction func addAddressSwitch(_ sender: UISwitch) {
        addAddressAppear()
    }
    
    func addAddressAppear() {
        UIView.animate(withDuration: 0.6) { [self] in
            addressOutlets.forEach { outlet in
                outlet.isHidden = !outlet.isHidden
            }
        }
    }
    
    @IBAction func cancelEdit(_ sender: Any) {
        reloadView()
        editMode = false
    }
    
    @IBAction func confirmEdit(_ sender: Any) {
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
        if (streetAndNumberAddress.text != "" && postalCodeAddress.text != "" && cityAddress.text != "" && countryAddress.text != "") {
            // Vérification que l'adresse complète est bien valide.
            GeolocHandler.shared.forwardGeocoding(
                address: streetAndNumberAddress.text + ", " + postalCodeAddress.text + " " + cityAddress.text + " " + countryAddress.text
            ) { [self] location in
                if location == nil {
                    AlertPopupHelper.shared.popupAlert(
                        titre: "Localisation introuvable",
                        message: "L'adresse entrée n'est pas valide, veuillez vérifier l'orthographe.",
                        viewController: self
                    )
                    return
                }
            }
        } else if (streetAndNumberAddress.text != "" || postalCodeAddress.text != "" || cityAddress.text != "" || countryAddress.text != "") {
            AlertPopupHelper.shared.popupAlert(
                titre: "Champ invalide",
                message: "Veuillez saisir tous les champs de l'adresse, ou ne saisir aucune adresse.",
                viewController: self
            )
            return
        }
        
        CoreDataHandler.shared.updateTask(
            task: task!,
            newTitre: taskTitle.text,
            newDesc: taskDescription.text,
            newDate: dueDate.date,
            newAdresse: streetAndNumberAddress.text,
            newCity: cityAddress.text,
            newCountry: countryAddress.text,
            newPostalCode: postalCodeAddress.text,
            newCompleteAdress: streetAndNumberAddress.text + ", " + postalCodeAddress.text + " " + cityAddress.text + " " + countryAddress.text,
            newImportant: importantSwitch.isOn
        )
        
        AlertPopupHelper.shared.showAlert(
            title: "Réussite",
            message: "Modification réussie !",
            viewController: self
        )
        
        reloadView()
    }
}
