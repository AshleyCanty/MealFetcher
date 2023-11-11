//
//  NetworkManager.swift
//  MealFetcher
//
//  Created by ashley canty on 11/4/23.
//

import UIKit
import Combine


/// A general Network Manager for use in different API services. Returns a publisher to the caller.
struct NetworkManager {
    public func createRequest<T:Codable>(url: URL,
                                          type: T.Type) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let response = element.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else { throw NetworkError.invalidData }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error in
                switch error {
                case is Swift.DecodingError:
                    return NetworkError.failedToDecode(error: error)
                case is URLError:
                    return NetworkError.invalidUrl
                default:
                    return NetworkError.other(error: error)
                }
            })
            .eraseToAnyPublisher()
    }
    
    public func createRequestWithMapping<T:Codable>(url: URL,
                                          type: T.Type) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let response = element.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else { throw NetworkError.invalidData }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error in
                switch error {
                case is Swift.DecodingError:
                    return NetworkError.failedToDecode(error: error)
                case is URLError:
                    return NetworkError.invalidUrl
                default:
                    return NetworkError.other(error: error)
                }
            })
            .eraseToAnyPublisher()
    }
}

extension NetworkManager {
    enum NetworkError: Error {
        case invalidUrl
        case other(error: Error)
        case invalidData
        case failedToDecode(error: Error)
    }
}
