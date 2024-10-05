//
//  Geolocation.swift
//  CityWeather
//
//  Created by Alex Meraz on 10/3/24.
//

import Foundation

struct Geolocation: Codable {
    var name: String
    var lat: Double
    var lon: Double
    var country: String
    var state: String?
    
    init(name: String, lat: Double, lon: Double, country: String, state: String?) {
        self.name = name
        self.lat = lat
        self.lon = lon
        self.country = country
        self.state = state
    }
    
    init(lat: Double, lon: Double) {
        self.name = ""
        self.lat = lat
        self.lon = lon
        self.country = ""
        self.state = nil
    }
}
