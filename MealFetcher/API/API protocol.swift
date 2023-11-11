//
//  File.swift
//  MealFetcher
//
//  Created by ashley canty on 11/2/23.
//

import UIKit
import Combine


protocol API {
    static var baseURL: URL { get }
    static var queryName: String? { get }
}

enum APIs {}

extension RawRepresentable where RawValue == String, Self: API {
    /// Constructs and returns a URL using query params
    var urlWithQuery: URL {
        var urlComponents = URLComponents(string: Self.baseURL.absoluteString)!
        urlComponents.queryItems = [URLQueryItem(name: Self.queryName ?? "", value: rawValue)]
        return urlComponents.url ?? Self.baseURL
    }
        
    init?(rawValue: String) { nil }
}


