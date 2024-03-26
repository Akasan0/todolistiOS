//
//  WeatherDataRaw.swift
//  TodoList
//
//  Created by Anaël BARODINE on 26/03/2024.
//

import Foundation

// Decodable est utilisé qd on a besoin de récupérer la donnée depuis un format extétieur (fichier JSON par exemple)

struct WeatherDataRaw : Decodable {
    var main : Main
    struct Main : Decodable {
        var temp : Double
        var temp_max: Double
        var temp_min: Double
    }
    var weather: [Weather]
    struct Weather : Decodable {
        var id : Int
    }
}
