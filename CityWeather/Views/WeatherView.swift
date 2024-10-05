//
//  WeatherView.swift
//  CityWeather
//
//  Created by Alex Meraz on 10/3/24.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel(weatherService: WeatherService(), locationManager: LocationManager())
    @State private var city: String = ""
    
    var body: some View {
        VStack {
            TextField("Search for a city", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocorrectionDisabled(true)
                .onChange(of: city) { _, newValue in
                    viewModel.fetchGeolocations(for: newValue)
                }
            
            // Display error message if there's one
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // Display list of suggestions only when there are valid suggestions
            if !viewModel.geolocations.isEmpty {
                CitySuggestionsView(geolocations: viewModel.geolocations) { selectedCity in
                    viewModel.fetchWeather(for: selectedCity)
                    
                    // Clear the search text field
                    city = ""
                    // Dismiss the keyboard (remove first responder)
                    UIApplication.shared.endEditing(true)
                }
            }
            
            Spacer()
            
            // Show the weather data when available
            if let weather = viewModel.weather {
                WeatherDetailsView(weather: weather)
            }
            
            Spacer()
            
        }
        .padding()
        .onAppear {
            // Check if the user has searched for a city before
            if viewModel.hasUserSearchedForCity() {
                viewModel.loadLastSearchedGeolocation()
            } else {
                viewModel.loadLocationManager()
            }
            
            viewModel.observeLocationChanges()
        }
    }
}

#Preview {
    WeatherView()
}
