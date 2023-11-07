//
//  RecipeInformationFetcher.swift
//  sfr3test
//
//  Created by Mike on 11/2/23.
//

import Alamofire
import Foundation

protocol RecipeInformationFetcher {
    func loadInfo(for id: Int) async throws -> RecipeInformation
}

class SpoonacularRecipeInformationFetcher: RecipeInformationFetcher {
    struct Params: Encodable {
        let includeNutrition: Bool = false
        let apiKey: String = SpoonacularRequest.apiKey
    }
    
    func loadInfo(for id: Int) async throws -> RecipeInformation {
        try await SpoonacularRequest.information(id: id).request
            .validate()
            .serializingDecodable(RecipeInformation.self).value
    }
}
