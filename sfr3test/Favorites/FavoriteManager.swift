//
//  FavoriteManager.swift
//  sfr3test
//
//  Created by Mike on 11/2/23.
//

import Foundation


class FavoriteManager: ObservableObject {
    static let shared = FavoriteManager()
    
    @Published private(set) var favorites: [RecipeInformation] = []
    private var favoriteIds: Set<Int> = []
    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("sfr3_favorites_cache.json", conformingTo: .json)
    }
    private let fileIOQueue = DispatchQueue(label: "fileIOQueue", qos: .default)
    
    private init() {
        loadFavorites()
    }
    
    func isFavorited(id: Int) -> Bool {
        favoriteIds.contains(id)
    }
    
    func isFavorited(recipe: RecipeInformation) -> Bool {
        favoriteIds.contains(recipe.id)
    }
    
    func favorite(recipe: RecipeInformation) {
        guard !favoriteIds.contains(recipe.id) else { return }
        favorites.append(recipe)
        favoriteIds.insert(recipe.id)
        saveFavorites()
    }
    
    func removeFavorite(recipe: RecipeInformation) {
        guard let favoriteIndex = favorites.firstIndex(where: { $0.id == recipe.id}) else { return }
        favorites.remove(at: favoriteIndex)
        favoriteIds.remove(recipe.id)
        saveFavorites()
    }
    
    func toggleFavorite(for recipe: RecipeInformation) {
        if favoriteIds.contains(recipe.id) {
            removeFavorite(recipe: recipe)
        } else {
            favorite(recipe: recipe)
        }
    }
    
    private func loadFavorites() {
        fileIOQueue.async {
            do {
                self.favorites = (try [RecipeInformation].decodedFrom(file: self.fileURL)) ?? []
                self.favoriteIds = .init(self.favorites.map { $0.id} )
            } catch {
                print(error)
            }
        }
    }
    
    private func saveFavorites() {
        fileIOQueue.async {
            do {
                try self.favorites.encoded(to: self.fileURL)
            } catch {
                print(error)
            }
        }
    }
}
