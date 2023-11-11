//
//  Category+Model.swift
//  MealFetcher
//
//  Created by ashley canty on 11/2/23.
//

import Foundation


// MARK: - Dessert

/// CategoryMeals
struct CategoryMeals: Codable {
    var meals: [Meal]
    
    enum CodingKeys: String, CodingKey {
        case meals
    }
    
    mutating func sortAlphabetically() {
        meals = meals.sorted { $0.name < $1.name }
    }
}

/// Meal
struct Meal: Codable {
    let name: String
    let thumb: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case thumb = "strMealThumb"
        case id = "idMeal"
    }
}
