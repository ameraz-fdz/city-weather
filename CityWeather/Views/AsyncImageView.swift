//
//  AsyncImageView.swift
//  CityWeather
//
//  Created by Alex Meraz on 10/4/24.
//

import SwiftUI

struct AsyncImageView: View {
    @StateObject private var loader = ImageLoader()
    let url: URL
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                // Placeholder or progress indicator while loading
                ProgressView()
            }
        }
        .onAppear {
            loader.loadImage(from: url)
        }
        .onChange(of: url) { _, newURL in
            loader.loadImage(from: newURL) // Reload when URL changes
        }
    }
}
