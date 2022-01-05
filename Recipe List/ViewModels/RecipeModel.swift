//
//  RecipeModel.swift
//  Recipe List
//
//  Created by Vu Trinh on 6/30/21.
//

import Foundation

class RecipeModel: ObservableObject {
    @Published var recipes = [Recipe]()
    @Published var categories = Set<String>()
    @Published var selectedCategory:String?
    @Published var favoriteRecipes = [Recipe]()
    
    static func getPortion(ingredient:Ingredient, recipeServings:Int, targetServings:Int) -> String {
        
        var portion = ""
        var numerator = ingredient.num ?? 1
        var denominator = ingredient.denom ?? 1
        var wholePortions = 0
        
        if ingredient.num != nil {
            // Get a single serving size by multiplying denominator by the recipe servings
            denominator *= recipeServings
            
            // Get target portion by multiplying numerator by target servings
            numerator *= targetServings
            
            // Reduce fraction the by greatest common divisor
            let divisor = Rational.greatestCommonDivisor(numerator, denominator)
            numerator /= divisor
            denominator /= divisor
            
            // Get the whole portion if numerator > denominator
            if (numerator >= denominator) {
                // Calculate the whole portion
                wholePortions = numerator / denominator
                
                //Calculate the remainder
                numerator = numerator % denominator
                
                // Assign to portion string
                portion += String(wholePortions)
            }
            
            // Express the remainder as a fraction
            if (numerator > 0) {
                portion += wholePortions > 0 ? " " : ""
                portion += "\(numerator)/\(denominator)"
            }
            
        }
        
        if var unit = ingredient.unit {
            
            // Check if we need to pluralize
            if wholePortions > 1 {
                // Calculate appropriate suffix
                if unit.suffix(2) == "ch" {
                    unit += "es"
                }
                else if unit.suffix(1) == "f" {
                    unit = String(unit.dropLast())
                    unit += "ves"
                }
                else {
                    unit += "s"
                }
            }
            
            
            portion += ingredient.num == nil && ingredient.denom == nil ? "" : " "
            
            return portion + unit
        }
        
        return portion
    }
    
    func updateFavourite(forName: String) {
        if let index = recipes.firstIndex(where: { $0.name == forName }) {
            if !recipes[index].isFavourite {
                recipes[index].isFavourite = true
                favoriteRecipes.append(recipes[index])
            }
            else {
                recipes[index].isFavourite = false
                if let indexRemove = favoriteRecipes.firstIndex(where: { $0.name == forName }) {
                    favoriteRecipes.remove(at: indexRemove)
                }
                    
            }
        }
    }
    
    init() {
        // Create an insteance of data service and get the data
        
        self.recipes = DataService.getLocalData().sorted{$0.name < $1.name}
        
        self.categories = Set(self.recipes.map{ r in
            return r.category
        })
        self.categories.update(with: Constants.defaultListing)
    }
}
