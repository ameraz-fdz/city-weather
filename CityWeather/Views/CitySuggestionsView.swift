//
//  CitySuggestionsView.swift
//  CityWeather
//
//  Created by Alex Meraz on 10/4/24.
//

import Foundation
import SwiftUI

struct CitySuggestionsView: View {
    var geolocations: [Geolocation]
    var onSelect: (Geolocation) -> Void
    
    var body: some View {
        List(geolocations, id: \.lat) { geolocation in
            Button(action: {
                onSelect(geolocation)
            }) {
                VStack(alignment: .leading) {
                    Text(geolocation.name)
                        .font(.headline)
                    if let state = geolocation.state {
                        Text("\(state), \(geolocation.country)")
                            .font(.subheadline)
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .frame(maxHeight: 350) // Limit list height to 6 items
    }
}
