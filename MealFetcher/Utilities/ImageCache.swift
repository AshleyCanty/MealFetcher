//
//  ImageCache.swift
//  MealFetcher
//
//  Created by ashley canty on 11/6/23.
//

import UIKit

/// ImageCache actor
actor ImageCache {
    /// stores url & data for an image
    private var cache: [URL: Data] = [:]
    /// store data for url
    func cacheImageData(_ data: Data, for url: URL) {
        cache[url] = data
    }

    /// retreive data for url
    func data(for url: URL) -> Data? {
        return cache[url]
    }

    /// Download image data
    func downloadImageData(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        cacheImageData(data, for: url)
        return data
    }
}

