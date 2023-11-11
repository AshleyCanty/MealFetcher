//
//  MealFetcherTests.swift
//  MealFetcherTests
//
//  Created by ashley canty on 11/2/23.
//

import XCTest
import Combine
import MealFetcher

@testable import MealFetcher

final class MealFetcherTests: XCTestCase {

    var mealAPIService: MockMealAPIService!
    var cancellables: Set<AnyCancellable>!

    let dessertList = CategoryMeals(meals: [Meal(name: "pie",  thumb: "imageURlPlaceholder", id: "52916")])

    override func setUp() {
        super.setUp()
        cancellables = []
        mealAPIService = MockMealAPIService()
    }

    override func tearDownWithError() throws {
        cancellables = []
        try super.tearDownWithError()
    }

    // - 1 Test Success for Fetching Desert Meals
    func testSuccessForFetchingDessertList() {
        var error: Error?
        let expectation = self.expectation(description: "Value Recieved")

        let fetchedDesserts: PassthroughSubject<CategoryMeals, Error>? = PassthroughSubject<CategoryMeals, Error>()
        let erasedFetchedDessertsPublisher = fetchedDesserts?.eraseToAnyPublisher()
        mealAPIService.fetchDessertListResult = erasedFetchedDessertsPublisher

        mealAPIService.fetchDessertList().sink { status in
            switch status {
            case .finished:
                print("Completed Request: \(status)")
                break
            case .failure(let err):
                error = error
                print("Error - failed to process: \(err.localizedDescription)")
                break
            }
            expectation.fulfill()
        } receiveValue: { dessertMeals in
            XCTAssertNotNil(dessertMeals)
            XCTAssertNotNil(dessertMeals.meals.first?.id)
            XCTAssertTrue(dessertMeals.meals.count > 0)
        }.store(in: &cancellables)

        fetchedDesserts?.send(dessertList)
        fetchedDesserts?.send(completion: .finished)

        XCTAssertNil(error)
        waitForExpectations(timeout: 1)
    }

    // - 2 Test Failure for Fetching Desert Meals
    func testFailureForFetchingDessertList() {
        var error: Error?
        let expectation = self.expectation(description: "Error occured")

        let fetchedDesserts: PassthroughSubject<CategoryMeals, Error>? = PassthroughSubject<CategoryMeals, Error>()
        let erasedFetchedDessertsPublisher = fetchedDesserts?.eraseToAnyPublisher()
        mealAPIService.fetchDessertListResult = erasedFetchedDessertsPublisher

        mealAPIService.fetchDessertList().sink { status in
            switch status {
            case .finished:
                print("Completed Request: \(status)")
                break
            case .failure(let err):
                error = err
                print("Error - failed to process: \(err.localizedDescription)")
                break
            }
            expectation.fulfill()
        } receiveValue: { value in
            XCTAssertNil(value)
        }.store(in: &cancellables)

        fetchedDesserts?.send(completion: .failure(NetworkManager.NetworkError.invalidData))

        XCTAssertNotNil(error)
        waitForExpectations(timeout: 1)
    }

    // - 3 Test Success for Fetching Meal Details
    func testSuccessForFetchingDetailList() {
        var error: Error?
        let mealId = dessertList.meals.first?.id ?? ""
        let expectation = self.expectation(description: "Value Recieved")

        let fetchedMealDetails: PassthroughSubject<Data, Error>? = PassthroughSubject<Data, Error>()
        let erasedMealDetailPublisher = fetchedMealDetails?.eraseToAnyPublisher()
        mealAPIService.fetchMealDetailsResult = erasedMealDetailPublisher

        mealAPIService.fetchMealDetails(mealId: mealId).sink { status in
            switch status {
            case .finished:
                print("Completed Request: \(status)")
                break
            case .failure(let err):
                error = error
                print("Error - failed to process: \(err.localizedDescription)")
                break
            }
            expectation.fulfill()
        } receiveValue: { _ in }.store(in: &cancellables)

        fetchedMealDetails?.send(Data())
        fetchedMealDetails?.send(completion: .finished)

        XCTAssertNil(error)
        waitForExpectations(timeout: 1)
    }


    // - 4 Test Faillure for Fetching Meal Details
    func testFetchForMealDetailsList() {
        var error: Error?
        let mealId = dessertList.meals.first?.id ?? ""
        let expectation = self.expectation(description: "Error occured")

        let fetchedMealDetails: PassthroughSubject<Data, Error>? = PassthroughSubject<Data, Error>()
        let erasedMealDetailPublisher = fetchedMealDetails?.eraseToAnyPublisher()
        mealAPIService.fetchMealDetailsResult = erasedMealDetailPublisher

        mealAPIService.fetchMealDetails(mealId: mealId).sink { status in
            switch status {
            case .finished:
                print("Completed Request: \(status)")
                break
            case .failure(let err):
                error = err
                print("Error - failed to process: \(err.localizedDescription)")
                break
            }
            expectation.fulfill()
        } receiveValue: { _ in }.store(in: &cancellables)

        fetchedMealDetails?.send(completion: .failure(NetworkManager.NetworkError.invalidData))

        XCTAssertNotNil(error)
        waitForExpectations(timeout: 1)
    }
}

/// MockMealAPIService
class MockMealAPIService: MealAPIServiceProtocol {

    var fetchDessertListResult: AnyPublisher<CategoryMeals, Error>?
    var fetchMealDetailsResult: AnyPublisher<Data, Error>?

    func fetchDessertList() -> AnyPublisher<CategoryMeals, Error> {
        if let result = fetchDessertListResult {
            return result
        } else {
            fatalError("result must not be nil")
        }
    }

    func fetchMealDetails(mealId: String) -> AnyPublisher<Data, Error> {
        if let result = fetchMealDetailsResult{
            return result
        } else {
            fatalError("result must not be nil")
        }
    }
}
