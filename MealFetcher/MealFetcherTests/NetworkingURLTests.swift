//
//  NetworkingEndpointTests.swift
//  MealFetcherTests
//
//  Created by ashley canty on 11/6/23.
//

import XCTest
@testable import MealFetcher
import Combine

final class NetworkingURLTests: XCTestCase {

    let path = "/api/json/v1/1/filter.php"
    let placeholdlerMealID = "52916"

    func test_that_DessertList_url_is_valid() {
        let urlComponents = URLComponents(string: APIs.MealDB.Category.Dessert.urlWithQuery.absoluteString)

        let queryName = APIs.MealDB.Category.queryName // "c"
        let urlString = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"

        XCTAssertEqual(urlComponents?.host, "themealdb.com", "The host should be themealdb.com")
        XCTAssertEqual(urlComponents?.path, "/api/json/v1/1/filter.php", "The path component should be '/api/json/v1/1/filter.php'")
        XCTAssertEqual(urlComponents?.queryItems?.first?.name, queryName, "The query name should be 'c'")
        XCTAssertEqual(urlComponents?.url?.absoluteString, urlString, "The generated url is not valid")
    }

    func test_that_MealDetail_url_is_valid() {
        let urlComponents = URLComponents(string: APIs.MealDB.MealDetails.meal(id: placeholdlerMealID).urlWithQuery.absoluteString)

        let queryName = APIs.MealDB.MealDetails.queryName // "i"
        let urlString = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(placeholdlerMealID)"

        XCTAssertEqual(urlComponents?.host, "themealdb.com", "The host should be themealdb.com")
        XCTAssertEqual(urlComponents?.path, "/api/json/v1/1/lookup.php", "The path component should be '/api/json/v1/1/lookup.php'")
        XCTAssertEqual(urlComponents?.queryItems?.first?.name, queryName, "The query name should be 'i'")
        XCTAssertEqual(urlComponents?.url?.absoluteString, urlString, "The generated url is not valid")
    }
}
