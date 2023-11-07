//
//  RecipeDetails.swift
//  sfr3test
//
//  Created by Mike on 11/2/23.
//

import Kingfisher
import SwiftUI

struct RecipeDetails: View {
    @StateObject var viewModel: RecipeDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                topSection
                list(with: "Ingredients", items: viewModel.ingredients)
                list(with: "Directions", items: viewModel.instructions)
            }
        }
    }
    
    @ViewBuilder
    var topSection: some View {
        VStack {
            image
            HStack {
                cookingTime
                Spacer()
                Button(action: viewModel.favorited, label: {
                    Image(systemName: viewModel.favoriteButtonImageName)
                        .foregroundStyle(viewModel.favoriteButtonForegroundColor)
                })
            }
        }
    }
    
    @ViewBuilder
    var image: some View {
        KFImage(viewModel.imageUrl)
            .placeholder({ Image(.coveredDish).resizable() })
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    @ViewBuilder
    var cookingTime: some View {
        Text(viewModel.cookingTime)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    func list(with title: String, items: [String]) -> some View {
        Text(title)
            .font(.title2)
            .frame(maxWidth: .infinity, alignment: .leading)
        ForEach(items, id: \.self) {
            Text($0)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

protocol RecipeInfo {
    var id: Int { get }
    var title: String { get }
    var imageUrl: URL? { get }
}

class RecipeDetailsViewModel: ObservableObject {
    private let recipe: RecipeInfo
    private let fetcher: RecipeInformationFetcher
    private var favoriteProvider: FavoriteManager
    @Published var fullRecipe: RecipeInformation?

    var imageUrl: URL? { recipe.imageUrl }
    var title: String { recipe.title }
    var cookingTime: String {
        guard let totalMinutes = fullRecipe?.readyInMinutes else { return "Quick Meal" }
        let hours = totalMinutes / 60
        let hoursText = hours > 0 ? "\(hours) hour\(hours != 1 ? "s" : "") " : ""
        let minutes = totalMinutes % 60
        let minuteText = minutes != 0 ? "\(minutes) minute\(minutes != 1 ? "s" : "")" : ""
        return "Cooking Time: \(hoursText)\(minuteText)".trimmingCharacters(in: .whitespaces)
    }
    var ingredients: [String] { fullRecipe?.extendedIngredients.compactMap { "・ \($0.name)" } ?? [] }
    var instructions: [String] { fullRecipe?.analyzedInstructions.first?.steps.compactMap { "\($0.number). \($0.step)" } ?? [] }
    var favoriteButtonImageName: String { favoriteProvider.isFavorited(id: recipe.id) ? "heart.fill" : "heart" }
    var favoriteButtonForegroundColor: Color { favoriteProvider.isFavorited(id: recipe.id) ? .red : .black }
    
    init(recipe: RecipeInfo, fetcher: RecipeInformationFetcher = SpoonacularRecipeInformationFetcher(), favoriteProvider: FavoriteManager = .shared) {
        self.recipe = recipe
        self.fetcher = fetcher
        self.favoriteProvider = favoriteProvider
        loadDetails()
    }
    
    func favorited() {
        guard let fullRecipe else { return }
        favoriteProvider.toggleFavorite(for: fullRecipe)
        
    }
    
    private func loadDetails() {
        Task {
            do {
                let info = try await fetcher.loadInfo(for: recipe.id)
                Task { @MainActor in
                    self.fullRecipe = info
                }
            } catch {
                handle(error)
            }
        }
    }
    
    private func handle(_ error: Error) {
        print(error)
    }
}

#Preview {
    RecipeDetails(viewModel: .init(recipe: RecipeCellViewModel(id: 1, title: "Eh, you know", imageUrl: nil)))
}
