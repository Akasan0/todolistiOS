//
//  TaskViewController.swift
//  todolist
//
//  Created by Anaël BARODINE on 13/03/2024.
//

import UIKit
import MapKit

class ViewTaskViewController: UIViewController, UITextViewDelegate {
    var editMode: Bool = false
    var tache: Tache?
    @IBOutlet var editOutlets: [UIView]!
    
    
    @IBOutlet weak var titreView: UITextField!
    @IBOutlet weak var separator: UILabel!
    @IBOutlet weak var separator1: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var dateEcheance: UIDatePicker!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // appearing outlets :
    
    
    @IBOutlet weak var adresseSwitch: UISwitch!
    @IBOutlet weak var adresseButton: UIButton!
    
    @IBOutlet weak var adr: UITextField!
    @IBOutlet weak var cp: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var editButtons: UIStackView!
    
    @IBOutlet weak var confirmerButton: UIButton!
    @IBOutlet weak var annulerButton: UIButton!
    var adresseOutlets: [UIView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionView.heightAnchor.constraint(equalToConstant: descriptionView.contentSize.height).isActive = true
        reloadView()
        
        // Do any additional setup after loading the view.
    }
    
    func reloadView(){
        UIView.animate(withDuration: 0.5){
            [self] in
            editOutlets.append(descriptionView)
            editOutlets.append(dateEcheance)
            
            titreView.text = tache?.titre
            titreView.isEnabled = false
            
            descriptionView.text = tache?.desc
            descriptionView.isEditable = false
            descriptionView.heightAnchor.constraint(equalToConstant: descriptionView.contentSize.height).isActive = true

            descriptionView.layer.borderWidth = 0
            
            dateEcheance.date = (tache?.date)!
            dateEcheance.isEnabled = false
            
            separator.backgroundColor = UIColor.black // Example separator color
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true // Example separator height
            
            separator1.backgroundColor = UIColor.black // Example separator color
            separator1.heightAnchor.constraint(equalToConstant: 1).isActive = true // Example separator height
            
            // Adresse loading
            adresseButton.isHidden = true
            adresseSwitch.isHidden = true
            
            adresseOutlets.append(adr)
            adr.text = tache?.adresse
            adresseOutlets.append(cp)
            cp.text = tache?.codePostal
            adresseOutlets.append(city)
            city.text = tache?.ville
            adresseOutlets.append(country)
            country.text = tache?.pays
            
            UIView.animate(withDuration: 0.6){
                [self] in
                adresseOutlets.forEach{
                    outlet in
                    outlet.isHidden = true
                }
            }
            
            editButtons.isHidden = true
            annulerButton.tintColor = .red
            
            descriptionView.delegate = self
            
            // map loading
            
            guard let adresse = tache?.adresse else {
                print("adresse inexistante")
                return
            }
            if (adresse == "" && tache?.codePostal == "" && tache?.ville == "" && tache?.pays == ""){
                mapView.isHidden = true
            } else{
                mapView.isHidden = false
                GeolocHandler.shared.forwardGeocoding(address: adresse) { [self]
                    location in
                    if let location = location {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location.coordinate
                        annotation.title = tache?.titre
                        annotation.subtitle = tache?.adresse
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
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        if (editMode){
            reloadView()
            editMode = false
        }else {
            goToEditMode()
            editMode = true
        }
    }
    
    func goToEditMode(){
        UIView.animate(withDuration: 0.6){
            [self] in
            titreView.isEnabled = true
            descriptionView.isEditable = !descriptionView.isEditable
            switch (descriptionView.layer.borderWidth){
            case 0.5 :
                descriptionView.layer.borderWidth = 0
            case 0 :
                descriptionView.layer.borderWidth = 0.5
            default:
                descriptionView.layer.borderWidth = 0.5
            }
            descriptionView.layer.borderWidth = 0.5
            descriptionView.layer.borderColor = UIColor.placeholderText.cgColor
            descriptionView.layer.cornerRadius = 5
            
            dateEcheance.isEnabled = true
            adresseButton.isHidden = false
            adresseSwitch.isHidden = false
            
            editButtons.isHidden = false
            
            mapView.isHidden = true
            
        }
    }
    
    
    @IBAction func addAdressButton(_ sender: Any) {
        adresseSwitch.isOn = !adresseSwitch.isOn
        addAdressAppear()
    }
    
    @IBAction func addAdressSwitch(_ sender: UISwitch) {
        addAdressAppear()
    }
    
    func addAdressAppear(){
        UIView.animate(withDuration: 0.6) {
            [self] in
            adresseOutlets.forEach{
                outlet in
                outlet.isHidden = !outlet.isHidden
            }
        }
    }
    
    @IBAction func annulerEdit(_ sender: Any) {
        reloadView()
        editMode = false
    }
    @IBAction func confirmerEdit(_ sender: Any) {
        guard let desc = descriptionView.text else {
            print("pb")
            return
        }
        guard let adresse = adr.text else {
            return
        }
        guard let cp = cp.text else {
            return
        }
        guard let city = city.text else { return
        }
        guard let pays = country.text else{
            return
        }
        let completeadress = adresse + ", " + cp +  " " + city + " " + pays
        
        if (completeadress != tache?.completeAdress){
            GeolocHandler.shared.forwardGeocoding(address: completeadress) { [self]
                location in
                if let location = location {
                    print("location : \(location)")
                    
//                    CoreDataHandler.shared.updateTask(tache: (tache)!, newTitre: titreView.text!, newDesc: descriptionView.text, newDate: dateEcheance.date, newAdresse: adresse, newCodepostal: cp, newCity: city, newCountry: country)
//                    
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    AlertPopupHelper.shared.popupAlert(titre: "No location", message: "L'adresse entrée n'est pas valide, veuillez vérifier l'orthographe.", viewController: self)
                }
            }
        }
    }
    
}
