//
//  RecipeListFetcher.swift
//  sfr3test
//
//  Created by Mike on 11/2/23.
//

import Alamofire
import Foundation

class RecipeListFetcher {
    struct Params: Encodable {
        let query: String
        let offset: Int
        let number: Int
        let limitLicense: Bool = true
        let apiKey: String = SpoonacularRequest.apiKey
    }
    
    let pageSize: Int
    let query: String
    
    private var currentOffset = 0
    private var isFetching = false
    private var totalResults: Int
    
    var canFetch: Bool { currentOffset < totalResults && !isFetching }
    
    init(query: String, pageSize: Int = 20) {
        self.query = query
        self.pageSize = pageSize
        self.totalResults = pageSize
    }
    
    func loadNextPage() async throws -> RecipeList? {
        guard canFetch else { return nil }
        isFetching = true
        defer { isFetching = false }
        
        let list = try await SpoonacularRequest.list(query: query, offset: currentOffset, pageSize: pageSize).request
            .validate()
            .serializingDecodable(RecipeList.self).value
        
        self.totalResults = list.totalResults
        self.currentOffset += pageSize
        
        return list
    }
}
