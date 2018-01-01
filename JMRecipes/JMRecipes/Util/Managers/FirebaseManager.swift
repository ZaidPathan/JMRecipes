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
    case fileUploadFailed
    case recipeDownloadError
}

class FirebaseManager {
    static let shared = FirebaseManager()
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
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
        var collectionPath = Const.FirestorePath.recipes
        
        if let imagePath = recipe.imagePath {
            data[Const.APIParams.imagePath] = imagePath
        } else if let videoPath = recipe.videoPath {
            data[Const.APIParams.videoPath] = videoPath
        } else {
            throw FirebaseError.invalidRecipeObject
        }
        
        ref = db.collection(collectionPath).addDocument(data: data, completion: completion)
    }
    
    func readRecipes(completion: @escaping (_ recipes: [Recipe]?, _ error: Error?)->()) {
        var arrRecipe = [Recipe]()
        db.collection(Const.FirestorePath.recipes).getDocuments { (snap, error) in
            if let snap = snap {
                for doc in snap.documents {
                    do {
                        let recipe = try Recipe(docData: doc.data())
                        arrRecipe.append(recipe)
                    } catch {
                        completion(nil, FirebaseError.recipeDownloadError)
                    }
                }
                completion(arrRecipe, nil)
            } else {
                completion(nil, FirebaseError.recipeDownloadError)
            }
        }
    }
    
    func updateRecipe() {
        
    }
    
    func deleteRecipe() {
        
    }
    
    func saveRecipeImage(image: UIImage, completion: @escaping (_ fileURL: String?, _ error: Error?)->()) {
        let recipeImages = Const.FireStoragepath.recipeImages
        
        let storageRef = storage.reference()
        let imageRef = storageRef.child(recipeImages+NSUUID().uuidString+".jpg")
        
        guard let imageData = UIImageJPEGRepresentation(image, 1) else {
            completion(nil, FirebaseError.fileUploadFailed)
            return
        }
        
        let uploadTask = imageRef.putData(imageData, metadata: nil) { (metaData, error) in
            guard let metaData = metaData else {
                debugPrint("Something went wrong")
                completion(nil, FirebaseError.fileUploadFailed)
                return
            }
            
            guard let fileDownloadURL = metaData.downloadURL() else {
                debugPrint("Something went wrong")
                completion(nil, FirebaseError.fileUploadFailed)
                return
            }
            
            completion(fileDownloadURL.absoluteString, nil)
            debugPrint("File uploaded at path: \(fileDownloadURL)")
        }
        
    }
}
