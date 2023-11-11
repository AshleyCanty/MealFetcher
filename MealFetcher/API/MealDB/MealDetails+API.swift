//
//  MealDetails+API.swift
//  MealFetcher
//
//  Created by ashley canty on 11/2/23.
//

import Foundation

// https://themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID

extension APIs.MealDB {
    enum MealDetails: RawRepresentable, API {
        static var baseURL: URL = URL(string: APIs.MealDB.baseURL.appendingPathComponent("lookup.php").absoluteString)!
        static var queryName: String? = "i"
        
        case meal(id: String)
        
        var rawValue: String {
            switch self {
            case .meal(let id): return id
            }
        }
    }
}
