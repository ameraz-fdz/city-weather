//
//  Weather.swift
//  CityWeather
//
//  Created by Alex Meraz on 10/3/24.
//

import Foundation

struct Weather: Decodable {
    let name: String
    let main: Main
    let weather: [WeatherDetail]
}

struct Main: Decodable {
    let temp: Double
    let humidity: Int
}

struct WeatherDetail: Decodable {
    let description: String
    let icon: String
}
