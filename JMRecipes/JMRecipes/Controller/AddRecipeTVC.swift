//
//  AddRecipeTVC.swift
//  JMRecipes
//
//  Created by Zaid Pathan on 29/12/17.
//  Copyright © 2017 Zaid Pathan. All rights reserved.
//

import UIKit
import AVFoundation
import PhotosUI

class AddRecipeTVC: UITableViewController {
    let cellTitles = ["Recipe Title", "Description", "Title Image", "Video Path"]
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            recipe = try Recipe(id: "" , title: "", description: "", imagePath: "", videoPath: "")
        } catch {
            debugPrint(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) || (indexPath.row == 3) {
            let textFieldCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as? TextFieldCell
            textFieldCell?.txtField.tag = indexPath.row
            textFieldCell?.txtField.placeholder = cellTitles[indexPath.row]
            textFieldCell?.txtField.delegate = self
            textFieldCell?.txtField.text = (indexPath.row == 0) ? recipe?.title : recipe?.videoPath
            textFieldCell?.tag = indexPath.row
            return textFieldCell!
        } else if (indexPath.row == 1) {
            let textViewCell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as? TextViewCell
            textViewCell?.txtView.delegate = self
            textViewCell?.txtView.text = recipe?.description
            return textViewCell!
        } else if (indexPath.row == 2) {
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? ImageCell
            imageCell?.imageView?.image = recipe?.image
            imageCell?.recipeImage.contentMode = UIViewContentMode.center
            return imageCell!
        } else if (indexPath.row == 4) {
            let labelCell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
            
            return labelCell
        } else {
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            addImage()
        } else if indexPath.row == 4 {
            saveRecipe()
        } else {
            
        }
    }
    
    func addImage() {
        func performCameraFunction(){
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                debugPrint("notDetermined")
            case .authorized:
                debugPrint("authorized")
            case .denied:
                showAlert(title: "Give access to Camera", message: "",b1Title:"Go to Settings", onB1Click: {
                    guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(settingsURL){
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                })
                
            case .restricted:
                debugPrint("restricted")
                
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.allowsEditing = true
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                debugPrint("Cam unavail")
            }
        }
        func performGalleryFunction(){
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                break
            case .denied:
                showAlert(title: "Give access to photos", message: "",b1Title:"Go to Settings", onB1Click: {
                    guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(settingsURL){
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                })
                break
            case .notDetermined:
                break
            case .restricted:
                break
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.allowsEditing = true
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                debugPrint("Photo Library unavail")
            }
        }
        
        let actionSheet = UIAlertController(title: "Choose Source", message: "", preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) { (action) in
            performGalleryFunction()
        }
        
        let camAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (action) in
            performCameraFunction()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        actionSheet.addAction(camAction)
        actionSheet.addAction(photoAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }

    func saveRecipe() {
        func addRecipe(recipe: Recipe) {
            do {
                startLoading()
                try FirebaseManager.shared.createRecipe(recipe: recipe) { (error) in
                    self.stopLoading()
                    
                    if let error = error {
                        self.showAlert(title: error.localizedDescription , message: nil, onB1Click: nil)
                    } else {
                        self.showAlert(title: Const.Alert.recipeStored , message: nil, onB1Click: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }
            } catch {
                stopLoading()
                self.showAlert(title: error.localizedDescription , message: nil, onB1Click: nil)
            }
        }
        
        if let title = recipe?.title, !title.isEmpty {
            
        } else {
            tableView.shake()
            return
        }
        
        if let description = recipe?.description, !description.isEmpty {
            
        } else {
            tableView.shake()
            return
        }
        
        if let recipeImage = recipe?.image {
            startLoading()
            FirebaseManager.shared.saveRecipeImage(image: recipeImage, completion: { (filePath, error) in
                self.stopLoading()
                
                if let filePath = filePath {
                    self.recipe?.imagePath = filePath
                    
                    if let videoPath = self.recipe?.videoPath, !videoPath.isEmpty, let _ = URL(string: videoPath) {
                        self.recipe?.videoPath = videoPath
                    } else {
                        return
                    }
                    
                    addRecipe(recipe: self.recipe!)
                } else {
                    self.showAlert(title: FirebaseError.fileUploadFailed.localizedDescription , message: nil, onB1Click: nil)
                    return
                }
            })
        } else {
            
        }
        
        if let videoPath = recipe?.videoPath, !videoPath.isEmpty, let _ = URL(string: videoPath) {
            self.recipe?.videoPath = videoPath
        } else {
            return
        }
        
        addRecipe(recipe: self.recipe!)
    }
}

extension AddRecipeTVC: UITextFieldDelegate, UITextViewDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            recipe?.title = textField.text!
        } else if textField.tag == 3 {
            recipe?.videoPath = textField.text
        } else {
            debugPrint("Unknown textfield")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        recipe?.description = textView.text
    }
}

extension AddRecipeTVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        recipe?.image = image
        tableView.reloadData()
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil);
    }
}
