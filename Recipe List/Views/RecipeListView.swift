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
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading) {
                /*
                Text(searching ? "Searching" : "All Recipes")
                    .bold()
                    .padding(.top, 40)
                    .font(Font.custom("Avenir Heavy", size: 30))
                 */
                
                SearchBar(searchRecipe: $searchRecipe, searching: $searching)
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(model.recipes.filter({(recipe: Recipe) -> Bool in
                            return recipe.name.contains(searchRecipe) || searchRecipe == ""
                        })) {
                        r in
                        NavigationLink(
                            destination: RecipeDetailView(recipe: r),
                            label: {
                                HStack(spacing: 20.0) {
                                    Image(r.image).resizable().scaledToFill().frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).clipped().cornerRadius(5)
                                    VStack(alignment: .leading) {
                                        Text(r.name)
                                            .font(Font.custom("Avenir Heavy", size: 16))
                                        RecipeHighlights(highlights: r.highlights)
                                    }.foregroundColor(.black)
                                }
                            })
                        }
                        .gesture(DragGesture()
                                    .onChanged({ _ in
                            UIApplication.shared.dismissKeyboard()
                        })
                                 )
                    }.padding(.top)
                    
                }
            }.navigationTitle(Text(searching ? "Searching" : "All Recipes"))
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
        .padding([.trailing, .top])
    }
}
