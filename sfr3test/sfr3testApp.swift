//
//  sfr3testApp.swift
//  sfr3test
//
//  Created by Mike on 11/2/23.
//

import SwiftUI

@main
struct sfr3testApp: App {
    @StateObject var searchViewModel = SearchRecipeListViewModel()
    @StateObject var favoriteViewModel = FavoriteLIstViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                RecipeListView(viewModel: searchViewModel)
                    .searchable(text: $searchViewModel.searchText, prompt: searchViewModel.searchPrompt)
                    .onSubmit(of: .search) { Task { await searchViewModel.searchTapped() } }
                    .padding()
                    .navigationTitle("Recipes")
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
                RecipeListView(viewModel: favoriteViewModel)
                    .navigationTitle("Favorites")
                    .tabItem { Label("Favorites", systemImage: "heart.fill") }
            }
        }
    }
}
