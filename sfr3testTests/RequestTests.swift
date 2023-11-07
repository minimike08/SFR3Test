//
//  RequestTests.swift
//  sfr3testTests
//
//  Created by Mike on 11/2/23.
//

import XCTest
@testable import sfr3test

final class RequestTests: XCTestCase {
    func testListRequest() {
        let request = SpoonacularRequest.list(query: "test", offset: 0, pageSize: 10)
        XCTAssertEqual(request.fullPath, "https://api.spoonacular.com/recipes/complexSearch")
    }
}
