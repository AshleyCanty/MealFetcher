//
//  DessertAPI.swift
//  MealFetcher
//
//  Created by ashley canty on 11/2/23.
//

import Foundation

// https://themealdb.com/api/json/v1/1/filter.php?c=Dessert

extension APIs.MealDB {
    enum Category: RawRepresentable, API {
        /// Compiler threw an error when I tried to just assign the URL object, so I opted for its absoluteString
        static var baseURL: URL = URL(string: APIs.MealDB.baseURL.appendingPathComponent("filter.php").absoluteString)!
        static var queryName: String? = "c"
        
        case Dessert
    
        var rawValue: String {
            switch self {
            case .Dessert: return "\(self)"
            }
        }
    }
}

