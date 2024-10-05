//
//  MockWeatherService.swift
//  CityWeather
//
//  Created by Alex Meraz on 10/5/24.
//

import Foundation
import Combine

class MockWeatherService: WeatherServiceProtocol {
    var fetchGeolocationsResult: Result<[Geolocation], Error>?
    var fetchWeatherResult: Result<Weather, Error>?

    func fetchGeolocations(for city: String, completion: @escaping (Result<[Geolocation], Error>) -> Void) {
        if let result = fetchGeolocationsResult {
            completion(result)
        }
    }

    func fetchWeather(for geolocation: Geolocation, completion: @escaping (Result<Weather, Error>) -> Void) {
        if let result = fetchWeatherResult {
            completion(result)
        }
    }
}
