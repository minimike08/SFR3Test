//
//  RecipeListCell.swift
//  sfr3test
//
//  Created by Mike on 11/2/23.
//

import Kingfisher
import SwiftUI

struct RecipeCell: View {
    let viewModel: RecipeCellViewModel
    
    var body: some View {
        VStack {
            KFImage(viewModel.imageUrl)
                .placeholder({ Image(.coveredDish).resizable() })
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(viewModel.title)
        }
    }
}

struct RecipeCellViewModel: RecipeInfo {
    let id: Int
    let title: String
    let imageUrl: URL?
}

extension RecipeCellViewModel {
    init(recipe: RecipeList.Recipe) {
        self.id = recipe.id
        self.title = recipe.title
        self.imageUrl = recipe.imageUrl
    }
}

#Preview {
    RecipeCell(viewModel: .init(id: 1, title: "A good recipe", imageUrl: nil))
}
