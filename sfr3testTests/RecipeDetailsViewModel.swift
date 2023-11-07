//
//  RecipeDetailsViewModel.swift
//  sfr3testTests
//
//  Created by Mike on 11/2/23.
//

import Combine
import XCTest
@testable import sfr3test

final class RecipeDetailsViewModelTests: XCTestCase {
    let recipe = RecipeCellViewModel(id: 1, cellTitle: "", imageUrl: nil)
    var cancellables: Set<AnyCancellable> = .init()
    
    func testViewModelNotLoaded() {
        let viewModel = RecipeDetailsViewModel(recipe: recipe, fetcher: MockRecipeInformationFetcher())
        XCTAssertEqual(viewModel.cookingTime, "Quick Meal")
    }
    
    func testViewModel() {
        let fetcher = MockRecipeInformationFetcher()
        let viewModel = RecipeDetailsViewModel(recipe: recipe, fetcher: fetcher)
        viewModel.fullRecipe = fetcher.recipe
            
        XCTAssertEqual(viewModel.cookingTime, "Cooking Time: 1 minute")
    }
    
    func testViewModel_2() {
        let fetcher = MockRecipeInformationFetcher()
        fetcher.recipe = fetcher.mockRecipeInformation3
        let viewModel = RecipeDetailsViewModel(recipe: recipe, fetcher: fetcher)
        viewModel.fullRecipe = fetcher.recipe
            
        XCTAssertEqual(viewModel.cookingTime, "Cooking Time: 2 hours 2 minutes")
    }
}

class MockRecipeInformationFetcher: RecipeInformationFetcher {
    lazy var recipe = mockRecipeInformation1
    
    func loadInfo(for id: Int) async throws -> RecipeInformation { recipe }
    
    var mockRecipeInformation1 = RecipeInformation(vegetarian: false, vegan: false, glutenFree: false, dairyFree: false, veryHealthy: false, cheap: false, veryPopular: false, sustainable: false, lowFodmap: false, weightWatcherSmartPoints: 1, gaps: "Text", preparationMinutes: 1, cookingMinutes: 1, aggregateLikes: 1, healthScore: 1, creditsText: "Text", sourceName: "Text", pricePerServing: 10.0, extendedIngredients: [], id: 1, title: "Text", readyInMinutes: 1, servings: 1, sourceUrl: "Text", image: "Text", imageType: "Text", summary: "Text", cuisines: ["Text"], dishTypes: ["Text"], instructions: "Text", analyzedInstructions: [], spoonacularSourceUrl: "Text")
    
    var mockRecipeInformation2 = RecipeInformation(vegetarian: false, vegan: false, glutenFree: false, dairyFree: false, veryHealthy: false, cheap: false, veryPopular: false, sustainable: false, lowFodmap: false, weightWatcherSmartPoints: 1, gaps: "Text", preparationMinutes: 1, cookingMinutes: 1, aggregateLikes: 1, healthScore: 1, creditsText: "Text", sourceName: "Text", pricePerServing: 10.0, extendedIngredients: [], id: 1, title: "Text", readyInMinutes: 60, servings: 1, sourceUrl: "Text", image: "Text", imageType: "Text", summary: "Text", cuisines: ["Text"], dishTypes: ["Text"], instructions: "Text", analyzedInstructions: [], spoonacularSourceUrl: "Text")
    
    var mockRecipeInformation3 = RecipeInformation(vegetarian: false, vegan: false, glutenFree: false, dairyFree: false, veryHealthy: false, cheap: false, veryPopular: false, sustainable: false, lowFodmap: false, weightWatcherSmartPoints: 1, gaps: "Text", preparationMinutes: 1, cookingMinutes: 1, aggregateLikes: 1, healthScore: 1, creditsText: "Text", sourceName: "Text", pricePerServing: 10.0, extendedIngredients: [], id: 1, title: "Text", readyInMinutes: 122, servings: 1, sourceUrl: "Text", image: "Text", imageType: "Text", summary: "Text", cuisines: ["Text"], dishTypes: ["Text"], instructions: "Text", analyzedInstructions: [], spoonacularSourceUrl: "Text")
}
