//
//  ImageCache.swift
//  CityWeather
//
//  Created by Alex Meraz on 10/4/24.
//

import Foundation
import SwiftUI
import Combine

class ImageCache {
    static let shared = ImageCache()
    
    private init() {}
    
    private let cache = NSCache<NSURL, UIImage>()
    
    func getImage(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    func setImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var cancellable: AnyCancellable?

    func loadImage(from url: URL) {
        // Cancel any previous image load
        cancellable?.cancel()

        // Check if the image is already cached
        if let cachedImage = ImageCache.shared.getImage(for: url) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            return
        }

        // If not cached, download the image
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloadedImage in
                if let image = downloadedImage {
                    // Cache the downloaded image
                    ImageCache.shared.setImage(image, for: url)
                }
                self?.image = downloadedImage
            }
    }

    deinit {
        cancellable?.cancel()
    }
}
