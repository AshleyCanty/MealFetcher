//
//  MealDBAPIService.swift
//  MealFetcher
//
//  Created by ashley canty on 11/6/23.
//

import UIKit
import Combine

extension APIs {
    enum MealDB: API {
        static var baseURL: URL = URL(string: "https://themealdb.com/api/json/v1/1")!
        static var queryName: String?
    }
}

/// MealAPIServiceProtocol
protocol MealAPIServiceProtocol {
    func fetchDessertList() -> AnyPublisher<CategoryMeals, Error>
    func fetchMealDetails(mealId: String) -> (AnyPublisher<Data, Error>)
}

/// class for MealDB API Service
class MealAPIService: MealAPIServiceProtocol {
    /// Fetches meals for dessert
    func fetchDessertList() -> AnyPublisher<CategoryMeals, Error> {
        return NetworkManager().createRequest(url: APIs.MealDB.Category.Dessert.urlWithQuery,
                                              type: CategoryMeals.self)
    }
    
    /// Fetches meal details
    func fetchMealDetails(mealId: String) -> (AnyPublisher<Data, Error>) {
        return URLSession.shared.dataTaskPublisher(for: APIs.MealDB.MealDetails.meal(id: mealId).urlWithQuery)
            .tryMap { element -> Data in
                guard let response = element.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else { throw NetworkManager.NetworkError.invalidData }
                return element.data
            }
//            .decode(type: MealDetailList.self, decoder: JSONDecoder())
            .mapError({ error in
                switch error {
                case is Swift.DecodingError:
                    return NetworkManager.NetworkError.failedToDecode(error: error)
                case is URLError:
                    return NetworkManager.NetworkError.invalidUrl
                default:
                    return NetworkManager.NetworkError.other(error: error)
                }
            })
            .eraseToAnyPublisher()
    }
}
