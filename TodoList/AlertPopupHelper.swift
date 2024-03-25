//
//  AlertPopupHelper.swift
//  TodoList
//
//  Created by tplocal on 23/03/2024.
//

import Foundation
import UIKit

class AlertPopupHelper{
    
    static let shared = AlertPopupHelper()
    
    func popupAlert(titre : String, message : String, viewController : UIViewController){
        let alertController = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, duration: Double = 2.0, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        viewController.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
}
