//
//  WeatherDetailsView.swift
//  CityWeather
//
//  Created by Alex Meraz on 10/4/24.
//

import Foundation
import SwiftUI

struct WeatherDetailsView: View {
    var weather: Weather
    
    var body: some View {
        VStack {
            Text(weather.name)
                .font(.largeTitle)

            // Display weather icon
            if let icon = weather.weather.first?.icon,
               let iconURL = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") {
                AsyncImageView(url: iconURL)
                    .frame(width: 100, height: 100)
            }
            Text("\(String(format: "%.0f", weather.main.temp)) °F")
                .font(.largeTitle)
            
            Text(weather.weather.first?.description ?? "")
                .font(.title)
            Text("Humidity: \(weather.main.humidity)%")
                .font(.subheadline)
        }
        .padding()
    }
}
