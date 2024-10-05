//
//  WeatherService.swift
//  CityWeather
//
//  Created by Alex Meraz on 10/3/24.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchGeolocations(for city: String, completion: @escaping (Result<[Geolocation], Error>) -> Void)
    func fetchWeather(for geolocation: Geolocation, completion: @escaping (Result<Weather, Error>) -> Void)
}

class WeatherService: WeatherServiceProtocol {
    private let apiKey = "a2aeb023c1f0c62e7f5ba5849a83d7ee"
    
    func fetchGeolocations(for city: String, completion: @escaping (Result<[Geolocation], Error>) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=6&appid=\(apiKey)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let geolocations = try JSONDecoder().decode([Geolocation].self, from: data)
                completion(.success(geolocations))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchWeather(for geolocation: Geolocation, completion: @escaping (Result<Weather, Error>) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(geolocation.lat)&lon=\(geolocation.lon)&appid=\(apiKey)&units=imperial") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
