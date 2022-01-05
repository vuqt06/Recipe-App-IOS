//
//  RecipeTabView.swift
//  Recipe List
//
//  Created by Vu Trinh on 7/7/21.
//

import SwiftUI
import UIKit

struct RecipeTabView: View {
    @State var selectedTab = Constants.tabView
    init() {
            UITabBar.appearance().backgroundColor = UIColor.black
        }
    var body: some View {
        TabView(selection: $selectedTab) {
            RecipeFeaturedView()
                .tabItem {
                    VStack {
                        Image(systemName: "star.fill")
                        Text("Featured")
                    }
                }.tag(Constants.tabView)
            
            RecipeCategoryView(selectedTab: $selectedTab)
                .tabItem {
                    VStack {
                        Image(systemName: "square.grid.2x2")
                        Text("Categories")
                    }
                }.tag(Constants.categoryView)

            
            RecipeListView()
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("List")
                    }
                }.tag(Constants.listView)
            
            FavouriteView()
                .tabItem {
                    VStack {
                        Image(systemName: "hand.thumbsup")
                        Text("Favorite")
                    }
                }.tag(Constants.favouriteView)
        }
        .environmentObject(RecipeModel())
    }
}

struct RecipeTabView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeTabView()
    }
}
