//
//  MockLocationManager.swift
//  CityWeather
//
//  Created by Alex Meraz on 10/5/24.
//

import Foundation
import Combine
import CoreLocation

class MockLocationManager {
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus? = .notDetermined

    func startUpdatingLocation() {
        // Simulate location updates by publishing a location
        location = CLLocation(latitude: 37.7749, longitude: -122.4194) // Example coordinates for San Francisco
    }

    func requestWhenInUseAuthorization() {
        // Simulate authorization change
        authorizationStatus = .authorizedWhenInUse
    }
}
