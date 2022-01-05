//
//  ContentView.swift
//  Recipe List
//
//  Created by Vu Trinh on 6/30/21.
//

import SwiftUI

// Kit frm UIKit which makes keyboard dissapear when hit Cancel button
extension UIApplication {
      func dismissKeyboard() {
          sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      }
  }
 

struct RecipeListView: View {
    
    // Reference the view model
    // Old attempt: @ObservedObject var model = RecipeModel()
    // New attempt:
    @EnvironmentObject var model:RecipeModel
    @State private var searchRecipe:String = ""
    @State var searching = false
    private var title:String {
        if (model.selectedCategory == nil || model.selectedCategory == Constants.defaultListing) {
            return "All Recipes"
        }
        else {
            return model.selectedCategory!
        }
    }
    
    
    let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W", "X","Y", "Z"]
    init() {
            UITabBar.appearance().barTintColor = UIColor.black
        }
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading) {
                
                Text(searching ? "Searching" : title)
                    .bold()
                    .padding(.top, 40)
                    .font(Font.custom("Avenir Heavy", size: 30))
                
                HStack {
                    SearchBar(searchRecipe: $searchRecipe, searching: $searching)
                    if (model.selectedCategory != nil && model.selectedCategory != Constants.defaultListing) {
                        Button {
                            model.selectedCategory = nil
                        } label: {
                            Text("All recipes")
                                .padding(.trailing)
                                .font(Font.custom("Avenir Heavy", size: 12))
                                .foregroundColor(.green)
                        }
                    }
                    

                }
                
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(model.recipes.filter({(recipe: Recipe) -> Bool in
                            return recipe.name.contains(searchRecipe) || searchRecipe == ""
                        })) {
                        r in
                            if (model.selectedCategory == nil || model.selectedCategory == Constants.defaultListing || (model.selectedCategory != nil && r.category == model.selectedCategory)) {
                                NavigationLink(
                                    destination: RecipeDetailView(recipe: r),
                                    label: {
                                        HStack(spacing: 20.0) {
                                            Image(r.image).resizable().scaledToFill().frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).clipped().cornerRadius(5)
                                            VStack(alignment: .leading) {
                                                Text(r.name)
                                                    .font(Font.custom("Avenir Heavy", size: 14))
                                                RecipeHighlights(highlights: r.highlights)
                                            }.foregroundColor(.black)
                                        }
                                    })
                            }
                        }
                        .gesture(DragGesture()
                                    .onChanged({ _ in
                            UIApplication.shared.dismissKeyboard()
                        }))
                    }.padding(.top)
                }
            }.navigationBarHidden(true)
            .padding(.leading)
            .toolbar {
                if searching {
                    Button("Cancel") {
                        searchRecipe = ""
                        withAnimation {
                            searching = false
                            UIApplication.shared.dismissKeyboard()
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
            .environmentObject(RecipeModel())
    }
}

struct SearchBar: View {
    @Binding var searchRecipe:String
    @Binding var searching:Bool
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("LightGray"))
                .cornerRadius(10)
            
            HStack() {
                Image(systemName: "magnifyingglass")
                TextField("Search ..", text: $searchRecipe) {
                    startedEditing in
                    if startedEditing {
                        withAnimation {
                            searching = true
                        }
                    }
                } onCommit: {
                    withAnimation {
                        searching = false
                    }
                }
            }
            .padding(.leading)
            .foregroundColor(.gray)
        }
        .frame(height: 40)
        .padding([.trailing])
    }
}
