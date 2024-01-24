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
