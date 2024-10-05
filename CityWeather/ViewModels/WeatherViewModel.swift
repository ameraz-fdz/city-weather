//
//  WeatherViewModel.swift
//  CityWeather
//
//  Created by Alex Meraz on 10/3/24.
//

import SwiftUI
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var geolocations: [Geolocation] = []
    @Published var weather: Weather?
    @Published var lastGeolocation: Geolocation?
    @Published var errorMessage: String?
    
    private var weatherService: WeatherServiceProtocol
    private var locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    private let LastGeolocationKey = "LastGeolocation"
    private let hasSearchedCityKey = "HasSearchedCity"
    
    init(weatherService: WeatherServiceProtocol, locationManager: LocationManager) {
        self.weatherService = weatherService
        self.locationManager = locationManager
    }
    
    func fetchGeolocations(for city: String) {
        guard city.count > 1 else {
            // Clear suggestions when city name is invalid
            DispatchQueue.main.async {
                self.geolocations = []
            }
            return
        }
        
        let encodedCity = city.urlEncoded()
        
        weatherService.fetchGeolocations(for: encodedCity) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let geolocations):
                    self?.geolocations = geolocations
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchWeather(for geolocation: Geolocation) {
        // Clear geolocations once the user selects a city in order to hide the suggestion list
        self.geolocations = []
        
        weatherService.fetchWeather(for: geolocation) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.weather = weather
                    self?.saveLastSearchedGeolocation(geolocation)
                    self?.setUserHasSearchedForCity()
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Save the last searched geolocation to UserDefaults
    func saveLastSearchedGeolocation(_ geolocation: Geolocation) {
        if let encodedGeolocation = try? JSONEncoder().encode(geolocation) {
            UserDefaults.standard.set(encodedGeolocation, forKey: LastGeolocationKey)
        }
    }
    
    // Load the last searched geolocation from UserDefaults
    func loadLastSearchedGeolocation() {
        if let savedGeolocation = UserDefaults.standard.object(forKey: LastGeolocationKey) as? Data,
           let loadedGeolocation = try? JSONDecoder().decode(Geolocation.self, from: savedGeolocation) {
            lastGeolocation = loadedGeolocation
            fetchWeather(for: loadedGeolocation) // Auto-load weather for the saved geolocation
        }
    }
    
    func loadLocationManager() {
        // Observe location changes
        self.locationManager.$location.sink { [weak self] (location: CLLocation?) in
            if let location = location {
                let currentLocation = Geolocation(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                self?.fetchWeather(for: currentLocation)
            }
        }.store(in: &cancellables)
    }
    
    func observeLocationChanges() {
        // Handle location authorization changes
        self.locationManager.$authorizationStatus.sink { [weak self] (status: CLAuthorizationStatus?) in
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                self?.locationManager.startUpdatingLocation()
            }
        }.store(in: &cancellables)
    }
    
    // Check if the user has searched for a city before
    func hasUserSearchedForCity() -> Bool {
        return UserDefaults.standard.bool(forKey: hasSearchedCityKey)
    }
    
    // Set the flag to indicate that the user has searched for a city
    func setUserHasSearchedForCity() {
        UserDefaults.standard.setValue(true, forKey: hasSearchedCityKey)
    }
}
