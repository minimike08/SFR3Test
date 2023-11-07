//
//  sfr3testTests.swift
//  sfr3testTests
//
//  Created by Mike on 11/2/23.
//

import XCTest
@testable import sfr3test

final class RecipeTests: XCTestCase {
    var bundle: Bundle { Bundle(for: RecipeTests.self) }
    
    func testRecipeList() throws {
        let list = try RecipeList.instanceDecodedFromJSONFile("RecipeSearchResponse", inBundle: bundle)
        XCTAssertEqual(list.results.count, 10)
        XCTAssertEqual(list.results.count(where: { $0.imageUrl == nil }), 0)
        XCTAssertEqual(list.offset, 0)
        XCTAssertEqual(list.number, 10)
        XCTAssertEqual(list.totalResults, 54)
    }
    
    func testRecipeInformation() throws {
        let information = try RecipeInformation.instanceDecodedFromJSONFile("RecipeInformationResponse", inBundle: bundle)
        XCTAssertEqual(information.id, 637631)
        XCTAssertEqual(information.extendedIngredients.count, 14)
        XCTAssertEqual(information.analyzedInstructions.first?.steps.count, 5)
    }
}
