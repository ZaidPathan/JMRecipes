//
//  Recipe.swift
//  JMRecipes
//
//  Created by Zaid Pathan on 29/12/17.
//  Copyright © 2017 Zaid Pathan. All rights reserved.
//

import Foundation
import UIKit

enum RecipeError: Error {
    case badRecipeAppearance
    case recipeCreationError
}

class Recipe {
    var id: String
    var title: String
    var description: String
    var imagePath: String?
    var image: UIImage?
    var videoPath: String?
    
    init(id: String, title: String, description: String, imagePath: String?,videoPath: String?) throws {
        self.id = id
        self.title = title
        self.description = description
        self.imagePath = imagePath
        self.videoPath = videoPath
        
        //Don't allow If both ImagePath and VideoPath nil
        guard (imagePath != nil) && (videoPath != nil) else {
            throw RecipeError.badRecipeAppearance
        }
    }
    
    init(docData: [String: Any], id: String) throws {
        self.id = id
        
        if let title = docData[Const.APIParams.title] as? String {
            self.title = title
        } else {
            throw RecipeError.recipeCreationError
        }
        
        if let description = docData[Const.APIParams.description] as? String {
           self.description = description
        } else {
            throw RecipeError.recipeCreationError
        }
        
        if let imagePath = docData[Const.APIParams.imagePath] as? String {
            self.imagePath = imagePath
        } else {
            if let videoPath = docData[Const.APIParams.videoPath] as? String {
               self.videoPath = videoPath
            } else {
                throw RecipeError.recipeCreationError
            }
        }
    }
}
