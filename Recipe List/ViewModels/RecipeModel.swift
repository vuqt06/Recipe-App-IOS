//
//  RecipeModel.swift
//  Recipe List
//
//  Created by Vu Trinh on 6/30/21.
//

import Foundation

class RecipeModel: ObservableObject {
    @Published var recipes = [Recipe]()
    
    init() {
        // Create an insteance of data service and get the data
        
        self.recipes = DataService.getLocalData()
        
    }
}
