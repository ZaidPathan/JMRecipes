//
//  Const.swift
//  JMRecipes
//
//  Created by Zaid Pathan on 29/12/17.
//  Copyright © 2017 Zaid Pathan. All rights reserved.
//

import Foundation

struct Const {
    struct Cells {
        static let recipeListCell = "RecipeListCell"
    }
    
    struct FirestorePath {
        static let recipes = "recipes"
    }
    
    struct FireStoragepath {
        static let recipeImages = "recipeImages/"
    }
    
    struct APIParams {
        static let id = "id"
        static let title = "title"
        static let description = "description"
        static let imagePath = "imagePath"
        static let videoPath = "videoPath"
    }
    
    struct Alert {
        static let oneFileNeeded = "Image or Valid Video URL, any one of them is required."
        static let recipeStored = "Recipe Stored Successfully"
    }
    
    struct Label {
        static let noRecipeFound = "No recipe found at this moment :("
    }
}
