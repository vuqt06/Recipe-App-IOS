//
//  RecipeCategoryView.swift
//  Recipe List
//
//  Created by Vu Trinh on 1/3/22.
//

import SwiftUI

struct RecipeCategoryView: View {
    @EnvironmentObject var model:RecipeModel
    @Binding var selectedTab:Int
    var body: some View {
        VStack(alignment: .leading) {
            Text("Categories")
                .bold()
                .padding(.top, 40)
                .font(Font.custom("Avenir Heavy", size: 30))
            
            GeometryReader {
                geo in
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 20, alignment: .top), GridItem(.flexible(), spacing: 20, alignment: .top)], alignment: .center, spacing: 20) {
                        ForEach(Array(model.categories).sorted{$0 < $1}, id: \.self) {category in
                            Button {
                                selectedTab = Constants.listView
                                model.selectedCategory = category
                            } label: {
                                VStack {
                                    Image(category)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (geo.size.width - 20)/2, height: (geo.size.width - 20)/2)
                                        .cornerRadius(10)
                                        .clipped()
                                    Text(category)
                                        .foregroundColor(.black)
                                }
                            }

                        }
                    }.padding(.bottom, 30)
                }

            }
            
        }.padding(.horizontal)
    }
}
