//
//  GeolocHandler.swift
//  TodoList
//
//  Created by tplocal on 23/03/2024.
//

import Foundation
import UIKit
import CoreLocation

class GeolocHandler {
    
    static let shared = GeolocHandler()
    
    func forwardGeocoding(address: String, completion: @escaping (CLLocation?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print("Failed to retrieve location")
                completion(nil)
                return
            }
            
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                print("No location found for address: \(address)")
                completion(nil)
                return
            }
            print("location found")
            completion(location)
        })
    }
}
