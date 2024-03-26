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
    
    // Météo
    @IBOutlet weak var meteoView: UIStackView!
    @IBOutlet weak var meteoImage: UIImageView!
    @IBOutlet weak var meteoTemp: UILabel!
    @IBOutlet weak var meteoTempMin: UILabel!
    @IBOutlet weak var meteoTempMax: UILabel!
    
    // Boutons de confirmation ou d'annulation.
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelOrConfirmButtons: UIStackView!
    
    // Attributs de view.
    let weatherUrlApiKey: String = "https://api.openweathermap.org/data/2.5/weather?appid=8a2197bbb3b34282c157fa4019483f44&units=metric"
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
            taskTitle.text = task?.title
            taskTitle.isEnabled = false
            
            // Description.
            taskDescription.text = task?.desc
            taskDescription.isEditable = false
            // Contrainte pour que la hauteur corresponde au texte saisi.
            taskDescription.heightAnchor.constraint(equalToConstant: taskDescription.contentSize.height).isActive = true
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
            addressSwitch.isOn = false
            
            // Adresse.
            addressOutlets.append(streetAndNumberAddress)
            streetAndNumberAddress.text = task?.streetAndNumber
            addressOutlets.append(postalCodeAddress)
            postalCodeAddress.text = task?.postalCode
            addressOutlets.append(cityAddress)
            cityAddress.text = task?.city
            addressOutlets.append(countryAddress)
            countryAddress.text = task?.country
            addressSwitch.isOn = false
            
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
                meteoView.isHidden = true
            } else {
                mapView.isHidden = false
                meteoView.isHidden = false
                let completeAddress = streetAndNumberAddress.text! + ", " + postalCodeAddress.text! + " " + cityAddress.text! + " " + countryAddress.text!
                GeolocHandler.shared.forwardGeocoding(address: (completeAddress)) { [self] location in
                    if let location = location {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location.coordinate
                        annotation.title = task?.title
                        annotation.subtitle = task?.streetAndNumber
                        let regionRadius: CLLocationDistance = 1000
                        let coordinateRegion = MKCoordinateRegion(
                            center: location.coordinate,
                            latitudinalMeters: regionRadius * 2.0,
                            longitudinalMeters: regionRadius * 2.0
                        )
                        mapView.setRegion(coordinateRegion, animated: true)
                        mapView.addAnnotation(annotation)
                        
                        loadCurrentWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                    }
                }
            }
        }
    }
    
    func isAddressGiven() -> Bool {
        if (task?.streetAndNumber == nil && task?.postalCode == nil && task?.city == nil && task?.country == nil) {
            return false
        } else if (task?.streetAndNumber == "" && task?.postalCode == "" && task?.city == "" && task?.country == "") {
            return false
        }
        
        return true
    }
    
    func loadCurrentWeather(lat: Double, lon: Double) {
        let texteURL = "\(weatherUrlApiKey)&lat=\(lat)&lon=\(lon)"
        let urlEncodee = texteURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard urlEncodee != nil else { debugPrint("Problème d'encodage de l'URL : \(texteURL)"); return }
        let url = URL(string: urlEncodee!)
        
        let session = URLSession(configuration: .default)
        let tache = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Problème lors de la requête : \(error!)")
            } else {
                if let data = data {
                    let dataDecode = JSONDecoder()
                    do {
                        let weatherDataRaw = try dataDecode.decode(WeatherDataRaw.self, from: data)
                        DispatchQueue.main.async {
                            self.meteoTemp.text = "\(weatherDataRaw.main.temp)°C"
                            self.meteoTempMax.text = "Max. \(weatherDataRaw.main.temp_max)°C"
                            self.meteoTempMin.text = "Min. \(weatherDataRaw.main.temp_min)°C"
                            
                            switch weatherDataRaw.weather[0].id {
                            case 200...232:
                                self.meteoImage.image = UIImage(systemName: "cloud.bolt.fill")
                            case 300...321:
                                self.meteoImage.image = UIImage(systemName: "cloud.drizzle.fill")
                            case 500...531:
                                self.meteoImage.image = UIImage(systemName: "cloud.rain.fill")
                            case 600...622:
                                self.meteoImage.image = UIImage(systemName: "cloud.snow.fill")
                            case 701...781:
                                self.meteoImage.image = UIImage(systemName: "cloud.fog.fill")
                            case 800:
                                self.meteoImage.image = UIImage(systemName: "sun.max.fill")
                            case 801...804:
                                self.meteoImage.image = UIImage(systemName: "cloud.bolt.fill")
                            default:
                                self.meteoImage.image = UIImage(systemName: "cloud.fill")
                            }
                        }
                    } catch {
                        print("Erreur lors du décodage : \(error)")
                    }
                } else {
                    print("Aucune donnée retournée")
                }
            }
        }
        tache.resume()
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
            
            // Météo
            meteoView.isHidden = true
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
                outlet.isHidden = !addressSwitch.isOn
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
            // Vérification que l'adresse complète est bien valide
            let completeAddress = streetAndNumberAddress.text! + ", " + postalCodeAddress.text! + " " + cityAddress.text! + " " + countryAddress.text!
            GeolocHandler.shared.forwardGeocoding(address: completeAddress) { [self] location in
                if let location = location {
                    CoreDataHandler.shared.updateTask(
                        task: task!,
                        newTitle: taskTitle.text!,
                        newDescription: taskDescription.text,
                        newDate: dueDate.date,
                        newIsImportant: importantSwitch.isOn,
                        newStreetAndNumber: streetAndNumberAddress.text,
                        newPostalCode: postalCodeAddress.text,
                        newCity: cityAddress.text,
                        newCountry: countryAddress.text
                    )
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
            
            CoreDataHandler.shared.updateTask(
                task: task!,
                newTitle: taskTitle.text!,
                newDescription: taskDescription.text,
                newDate: dueDate.date,
                newIsImportant: importantSwitch.isOn,
                newStreetAndNumber: streetAndNumberAddress.text,
                newPostalCode: postalCodeAddress.text,
                newCity: cityAddress.text,
                newCountry: countryAddress.text
            )
            AlertPopupHelper.shared.showAlert(
                title: "Réussite",
                message: "Modification réussie !",
                viewController: self
            )
        }
        
        
        
        reloadView()
    }
}
