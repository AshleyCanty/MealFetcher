//
//  ImageLoader+Caching.swift
//  MealFetcher
//
//  Created by ashley canty on 11/5/23.
//

import UIKit

extension UIImageView {
    /// Fetch image through a network request if it's not already cached and apply it to imageview. If neither options are available, then a placeholder image is applied.
    func downloadImage(from url: URL) async throws {
        let imageCache = ImageCache()

        if let cachedImageData = await imageCache.data(for: url) {
            self.image = UIImage(data: cachedImageData)
            return
        }

        let data = try await imageCache.downloadImageData(from: url)
        guard let newImage = UIImage(data: data) else {
            /// If all else fails, use a placeholder iamge
            self.image = UIImage(named: "placeholder")
            throw NSError(domain: "InvalidImageData", code: 0, userInfo: nil)
        }

        self.image = newImage
    }
}
