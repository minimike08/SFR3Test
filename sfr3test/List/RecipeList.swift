//
//  Recipe.swift
//  sfr3test
//
//  Created by Mike on 11/2/23.
//

import Foundation

struct RecipeList: Codable {
    let results: [Recipe]
    let offset: Int
    let number: Int
    let totalResults: Int
    
    struct Recipe: Codable {
        let id: Int
        let title: String
        let image: String
        let imageType: String
        
        var imageUrl: URL? { .init(string: image) }
    }
}
