//
//  FirebaseManager.swift
//  JMRecipes
//
//  Created by Zaid Pathan on 28/12/17.
//  Copyright © 2017 Zaid Pathan. All rights reserved.
//

import Foundation
import Firebase

enum FirebaseError: Error {
    case invalidRecipeObject
}

class FirebaseManager {
    static let shared = FirebaseManager()
    
    let db = Firestore.firestore()
    // Add a new document with a generated ID
    var ref: DocumentReference? = nil
    
    func configure() {
        
    }
    
    //Recipe Book CRUD
    func createRecipe(recipe: Recipe, completion: ((_ error: Error?)->())?) throws {
        var data: [String: Any] = [Const.APIParams.id: recipe.id,
                                   Const.APIParams.title:recipe.title,
                                   Const.APIParams.description:recipe.description]
        
        //If imagePath->Store recipe to book, else to videos
        var collectionPath = Const.FirestorePath.recipeBook
        
        if let imagePath = recipe.imagePath {
            data[Const.APIParams.imagePath] = imagePath
        } else if let videoPath = recipe.videoPath {
            data[Const.APIParams.videoPath] = videoPath
            collectionPath = Const.FirestorePath.videoRecipes
        } else {
            throw FirebaseError.invalidRecipeObject
        }
        
        ref = db.collection(collectionPath).addDocument(data: data, completion: completion)
    }
    
    func readRecipe() {
        
    }
    
    func updateRecipe() {
        
    }
    
    func deleteRecipe() {
        
    }
    
    //Recipe Video CRUD
}
