//
//  RecipeInformation.swift
//  sfr3test
//
//  Created by Mike on 11/2/23.
//

import Foundation

struct RecipeInformation: Codable, RecipeInfo {
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    let veryHealthy: Bool
    let cheap: Bool
    let veryPopular: Bool
    let sustainable: Bool
    let lowFodmap: Bool
    let weightWatcherSmartPoints: Int
    let gaps: String
    let preparationMinutes: Int
    let cookingMinutes: Int
    let aggregateLikes: Int
    let healthScore: Int
    let creditsText: String
    let sourceName: String
    let pricePerServing: Float
    let extendedIngredients: [Ingredient]
    let id: Int
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let sourceUrl: String
    let image: String
    var imageUrl: URL? { .init(string: image) }
    let imageType: String
    let summary: String
    let cuisines: [String]
    let dishTypes: [String]
    let instructions: String
    let analyzedInstructions: [Instructions]
    let spoonacularSourceUrl: String
    
    struct Ingredient: Codable {
        let id: Int
        let aisle: String?
        let image: String?
        let consistency: String?
        let name: String
        let nameClean: String?
        let original: String?
        let originalName: String?
        let amount: Float?
        let unit: String?
        let meta: [String]?
        let measures: Measures?
            
        struct Measures: Codable {
            let us: Measure
            let metric: Measure
            
            struct Measure: Codable {
                let amount: Float
                let unitShort: String
                let unitLong: String
            }
        }
    }
    
    struct Instructions: Codable {
        let name: String
        let steps: [Step]
        
        struct Step: Codable {
            let number: Int
            let step: String
            let ingredients: [Ingredient]
            let equipment: [Equipment]
                
            struct Ingredient: Codable {
                let id: Int
                let name: String
                let localizedName: String
                let image: String
            }
            
            struct Equipment: Codable {
                let id: Int
                let name: String
                let localizedName: String
                let image: String
            }
        }
    }
}
