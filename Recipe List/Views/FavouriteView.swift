//
//  FavouriteView.swift
//  Recipe List
//
//  Created by Vu Trinh on 1/4/22.
//

import SwiftUI

struct FavouriteView: View {
    @EnvironmentObject var model:RecipeModel
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Favorite Recipes")
                    .bold()
                    .padding(.top, 40)
                    .font(Font.custom("Avenir Heavy", size: 30))
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(model.favoriteRecipes.sorted{$0.name < $1.name}) { recipe in
                            if recipe.isFavourite {
                                NavigationLink(
                                    destination: RecipeDetailView(recipe: recipe),
                                    label: {
                                        HStack(spacing: 20.0) {
                                            Image(recipe.image).resizable().scaledToFill().frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).clipped().cornerRadius(5)
                                            VStack(alignment: .leading) {
                                                Text(recipe.name)
                                                    .font(Font.custom("Avenir Heavy", size: 14))
                                                RecipeHighlights(highlights: recipe.highlights)
                                            }.foregroundColor(.black)
                                        }
                                    })
                            }
                        }
                    }
                }
            }.padding()
                .navigationBarHidden(true)
        }
    }
}

struct FavouriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteView().environmentObject(RecipeModel())
    }
}
