//
//  ContentView.swift
//  sfr3test
//
//  Created by Mike on 11/2/23.
//

import Combine
import Kingfisher
import SwiftUI

struct RecipeListView: View {
    var columns: [GridItem] { Array(repeating: .init(.flexible()), count: 2) }
    
    @StateObject var viewModel: RecipeListViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(viewModel.recipes, id: \.id) { recipe in
                        NavigationLink {
                            RecipeDetails(viewModel: .init(recipe: recipe))
                                .navigationTitle(recipe.title)
                        } label: {
                            RecipeCell(viewModel: recipe)
                                .task {
                                    viewModel.didShow(recipe)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

class RecipeListViewModel: ObservableObject {
    @Published var recipes: [RecipeCellViewModel] = []
    
    func didShow(_ recipe: RecipeCellViewModel) {}
}

class FavoriteLIstViewModel: RecipeListViewModel {
    @Published private(set) var favoriteProvider: FavoriteManager
    
    init(favoriteProvider: FavoriteManager = .shared) {
        self.favoriteProvider = favoriteProvider
        super.init()

        favoriteProvider.$favorites
            .receive(on: DispatchQueue.main)
            .map({ recipes in recipes.map { RecipeCellViewModel(id: $0.id, title: $0.title, imageUrl: $0.imageUrl) }})
            .assign(to: &$recipes)
    }
}

class SearchRecipeListViewModel: RecipeListViewModel {
    var searchText = ""
    var searchPrompt: String { "Search for recipes" }
    
    private var recipeFetcher: RecipeListFetcher?
    
    func searchTapped() async {
        Task { @MainActor in recipes = [] }
        recipeFetcher = .init(query: searchText)
        await fetchNextPage()
    }
    
    override func didShow(_ recipe: RecipeCellViewModel) {
        super.didShow(recipe)
        loadNextPageIfNeeded(for: recipe)
    }
    
    private func loadNextPageIfNeeded(for recipe: RecipeCellViewModel) {
        guard recipe.id == recipes.last?.id && recipeFetcher?.canFetch == true else { return }
        Task { await fetchNextPage() }
    }
    
    private func fetchNextPage() async {
        do {
            if let results = try await recipeFetcher?.loadNextPage() {
                Task { @MainActor in
                    recipes.append(contentsOf: results.results.map { .init(recipe: $0) })
                }
            }
        } catch {
            handle(error)
        }
    }

    private func handle(_ error: Error) {
        print(error)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView(viewModel: .init() <- {
            $0.recipes = [
                .init(id: 1, title: "Recipe1", imageUrl: nil),
                .init(id: 2, title: "Recipe2", imageUrl: nil),
                .init(id: 3, title: "Recipe3", imageUrl: nil),
                .init(id: 4, title: "Recipe4", imageUrl: nil),
                .init(id: 5, title: "Really long recipe name because that seems to be the thing to do", imageUrl: nil),
                .init(id: 6, title: "Recipe5", imageUrl: nil),
                .init(id: 7, title: "Recipe6", imageUrl: nil),
                .init(id: 8, title: "Recipe7", imageUrl: nil)
            ]
        })
    }
}
