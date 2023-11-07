//
//  Requests.swift
//  sfr3test
//
//  Created by Mike on 11/2/23.
//

import Alamofire
import Foundation

enum SpoonacularRequest {
    static var apiKey = "e6ec72f3439b4c5196b1a8045e8c7a17" // not greatest spot, but ok for now
    
    case list(query: String, offset: Int, pageSize: Int)
    case information(id: Int)
    
    var host: String { "api.spoonacular.com" }
    var method: HTTPMethod { .get }
    var fullPath: String { "https://\(host)/\(path)" }
    var request: DataRequest { AF.request(fullPath, method: method, parameters: parameters) }
    
    var path: String {
        switch self {
        case .list: return "recipes/complexSearch"
        case .information(let id): return "recipes/\(id)/information"
        }
    }
    
    var parameters: any Encodable {
        switch self {
        case .list(let query, let offset, let pageSize):
            return RecipeListFetcher.Params(query: query, offset: offset, number: pageSize)
        case .information:
            return SpoonacularRecipeInformationFetcher.Params()
        }
    }
}
