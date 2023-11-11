//
//  MealDetails+Model.swift
//  MealFetcher
//
//  Created by ashley canty on 11/2/23.
//

import Foundation
import RegexBuilder

/// model struct for MealDetailsList
struct MealDetailList: Codable {
    let details: [MealDetails]?
    
    enum CodingKeys: String, CodingKey {
        case details = "meals"
    }
}

/// model struct for IngredientMeasure
struct Ingredient {
    let name: String
    let amount: String
}

/// model struct for MealDetails
struct MealDetails: Codable {
    let id: String?
    let name: String?
    var drink: String?
    let category: String?
    let area: String?
    let instructions: String?
    let thumb: String?
    let tags: String?
    let youtubeUrl: String?
    let source: String?
    let imageSource: String?
    let creativeCommonsConfirmed: String?
    let dateModified: String?
    
    private let ingredient1: String?
    private let ingredient2: String?
    private let ingredient3: String?
    private let ingredient4: String?
    private let ingredient5: String?
    private let ingredient6: String?
    private let ingredient7: String?
    private let ingredient8: String?
    private let ingredient9: String?
    private let ingredient10: String?
    private let ingredient11: String?
    private let ingredient12: String?
    private let ingredient13: String?
    private let ingredient14: String?
    private let ingredient15: String?
    private let ingredient16: String?
    private let ingredient17: String?
    private let ingredient18: String?
    private let ingredient19: String?
    private let ingredient20: String?
    
    private let measure1: String?
    private let measure2: String?
    private let measure3: String?
    private let measure4: String?
    private let measure5: String?
    private let measure6: String?
    private let measure7: String?
    private let measure8: String?
    private let measure9: String?
    private let measure10: String?
    private let measure11: String?
    private let measure12: String?
    private let measure13: String?
    private let measure14: String?
    private let measure15: String?
    private let measure16: String?
    private let measure17: String?
    private let measure18: String?
    private let measure19: String?
    private let measure20: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case drink = "strDrinkAlternate"
        case category = "strCategory"
        case area = "strArea"
        case instructions = "strInstructions"
        case thumb = "strMealThumb"
        case tags = "strTags"
        case youtubeUrl = "strYoutube"
        case source = "strSource"
        case imageSource = "strImageSource"
        case creativeCommonsConfirmed = "strCreativeCommonsConfirmed"
        case dateModified
        
        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
        case ingredient6 = "strIngredient6"
        case ingredient7 = "strIngredient7"
        case ingredient8 = "strIngredient8"
        case ingredient9 = "strIngredient9"
        case ingredient10 = "strIngredient10"
        case ingredient11 = "strIngredient11"
        case ingredient12 = "strIngredient12"
        case ingredient13 = "strIngredient13"
        case ingredient14 = "strIngredient14"
        case ingredient15 = "strIngredient15"
        case ingredient16 = "strIngredient16"
        case ingredient17 = "strIngredient17"
        case ingredient18 = "strIngredient18"
        case ingredient19 = "strIngredient19"
        case ingredient20 = "strIngredient20"
        
        case measure1 = "strMeasure1"
        case measure2 = "strMeasure2"
        case measure3 = "strMeasure3"
        case measure4 = "strMeasure4"
        case measure5 = "strMeasure5"
        case measure6 = "strMeasure6"
        case measure7 = "strMeasure7"
        case measure8 = "strMeasure8"
        case measure9 = "strMeasure9"
        case measure10 = "strMeasure10"
        case measure11 = "strMeasure11"
        case measure12 = "strMeasure12"
        case measure13 = "strMeasure13"
        case measure14 = "strMeasure14"
        case measure15 = "strMeasure15"
        case measure16 = "strMeasure16"
        case measure17 = "strMeasure17"
        case measure18 = "strMeasure18"
        case measure19 = "strMeasure19"
        case measure20 = "strMeasure20"
    }
}

extension MealDetails {
    /// Returns an array of IngredientMeasure objects
    func getIngredientMeasureList() -> [Ingredient] {
        let ingredients = getIngredientList()
        let measurements = getMeasureList()
        
        var list = [Ingredient]()
        let maxIndex = min(ingredients.count, measurements.count)
        for x in 0..<maxIndex {
            list.append(Ingredient(name: ingredients[x], amount: measurements[x]))
        }
        
        return list
    }
    
    /// Returns a new array without nil values and empty strings
    private func removeEmptyElements(optionalList: [String?]) -> [String] {
        let list = optionalList.compactMap { optionalString in
            if let string = optionalString, string.count > 0 {
                return string
            }
            return nil
        }
        return list
    }
    
    private func getIngredientList() -> [String] {
        let ingredientList: [String?] = [
            ingredient1,
            ingredient2,
            ingredient3,
            ingredient4,
            ingredient5,
            ingredient6,
            ingredient7,
            ingredient8,
            ingredient9,
            ingredient10,
            ingredient11,
            ingredient12,
            ingredient13,
            ingredient14,
            ingredient15,
            ingredient16,
            ingredient17,
            ingredient18,
            ingredient19,
            ingredient20
        ]
        
        return removeEmptyElements(optionalList: ingredientList)
    }
    
    private func getMeasureList() -> [String] {
        let measureList: [String?] = [
            measure1,
            measure2,
            measure3,
            measure4,
            measure5,
            measure6,
            measure7,
            measure8,
            measure9,
            measure10,
            measure11,
            measure12,
            measure13,
            measure14,
            measure15,
            measure16,
            measure17,
            measure18,
            measure19,
            measure20
        ]
        
        return removeEmptyElements(optionalList: measureList)
    }
}


/// a struct for parsing from the meal detail json string for ingredient/measurement values
struct IngredientRegexExtractor {
    
    private let validCharacters = CharacterClass("a"..."z", "A"..."Z", "0"..."9", .anyOf("/-,"))
    
    private let fractionalRegex = Regex {
        ChoiceOf {
            Fraction.localizedStringFromFraction(fraction: .Eighth)
            Fraction.localizedStringFromFraction(fraction: .Half)
            Fraction.localizedStringFromFraction(fraction: .Quarter)
            Fraction.localizedStringFromFraction(fraction: .Third)
            Fraction.localizedStringFromFraction(fraction: .ThreeQuarters)
            Fraction.localizedStringFromFraction(fraction: .TwoThirds)
        }
    }
    
    private let validUnits = Regex {
        ChoiceOf {
            "g"
            "oz"
            "cup"
            "cups"
            "lb"
            "lbs"
            "tbsp"
            "tsp"
        }
    }

    /// Extracts ingredients and measurements from json string and returns an array of Ingredient objects
    func findRegexMatchesForIngredients(withString optionalJsonString: String?) -> [Ingredient] {
        guard let jsonString = optionalJsonString, !jsonString.isEmpty else { return [] }
        /// For ingredients
        let regexIngredientPattern = Regex {
            
            Regex {
                "strIngredient"
                Capture { OneOrMore(("0"..."9")) }
                One(.any)
                ZeroOrMore(.whitespace)
                ":"
                ZeroOrMore(.whitespace)
                "\""
                Capture {
                    ChoiceOf {
                        OneOrMore {
                            OneOrMore(validCharacters)
                            "-"
                            OneOrMore(validCharacters)
                            ZeroOrMore(.whitespace)
                            ZeroOrMore(validCharacters)
                            ZeroOrMore(.whitespace)
                            ZeroOrMore(validCharacters)
                        }
                        OneOrMore {
                            OneOrMore(.word)
                            ZeroOrMore(.whitespace)
                            ZeroOrMore(.word)
                        }
                    }
                }
            }
        }
        
        /// For measurements
        let regexMeasurePattern = Regex {
            Regex {
                "strMeasure"
                Capture { OneOrMore(("0"..."9")) }
                One(.any)
                ZeroOrMore(.whitespace)
                ":"
                ZeroOrMore(.whitespace)
                "\""
                Capture {
                    ChoiceOf {
                        OneOrMore {
                            ZeroOrMore { fractionalRegex }
                            ZeroOrMore(.whitespace)
                            OneOrMore(validCharacters)
                            ZeroOrMore(.whitespace)
                            ZeroOrMore { validCharacters }
                        }
                        
                        OneOrMore {
                            OneOrMore(validCharacters)
                            One(validUnits)
                            One(.any)
                            ZeroOrMore(.digit)
                            ZeroOrMore { fractionalRegex }
                            One(validUnits)
                        }
                        
                        OneOrMore {
                            OneOrMore(validCharacters)
                            One(validUnits)
                        }
                    }
                }
            }
        }
        
        let ingredientMatches = jsonString.matches(of: regexIngredientPattern)
        let measurementMatches = jsonString.matches(of: regexMeasurePattern)

        let amountOfIngredientsMatches = ingredientMatches.count
        var ingredientList: [Ingredient] = []
        
        for x in 0..<amountOfIngredientsMatches {
            
            let matchingIngredient = ingredientMatches.first { Int($0.output.1) == (x+1) }
            let matchingMeasurement = measurementMatches.first { Int($0.output.1) == (x+1) }
            
            if let name = matchingIngredient?.output.2, let amount = matchingMeasurement?.output.2 {
                ingredientList.append(Ingredient(name: String(name), amount: String(amount)))
            }
        }

        return ingredientList
    }
}
