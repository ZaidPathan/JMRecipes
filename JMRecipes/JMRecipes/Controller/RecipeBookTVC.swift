//
//  RecipeBookTVC.swift
//  JMRecipes
//
//  Created by Zaid Pathan on 28/12/17.
//  Copyright © 2017 Zaid Pathan. All rights reserved.
//

import UIKit
import SDWebImage

class RecipeBookTVC: UITableViewController {

    @IBOutlet weak var btnAdd: UIButton!
    var arrRecipe: [Recipe]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRecipe()
    }
    
    private func setupOnLoad() {
        tableView.registerCell(id: Const.Cells.recipeListCell)
        btnAdd.isHidden = (Configuration.environment == .Release)
        
        arrRecipe = []
    }
    
    private func fetchRecipe() {
        FirebaseManager.shared.readRecipes { (arrRecipe, error) in
            guard let arrRecipe = arrRecipe else { return }
            self.arrRecipe = arrRecipe
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let arrRecipe = arrRecipe, !arrRecipe.isEmpty else {
            tableView.backgroundView = NoDataLabel.labelWithTitle(title: Const.Label.noRecipeFound, frame: tableView.frame)
            return 0
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrRecipe = arrRecipe, !arrRecipe.isEmpty else { return 0 }
        return arrRecipe.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipeListCell = tableView.dequeueReusableCell(withIdentifier: "RecipeListCell", for: indexPath) as? RecipeListCell
        recipeListCell?.recipeTitleLabel.text = arrRecipe?[indexPath.row].title
        
        if let imagePath = (arrRecipe?[indexPath.row].imagePath), let imageURL = URL(string: imagePath) {
            recipeListCell?.recipeImage.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "sampleDish"), options: SDWebImageOptions.highPriority, completed: { (image, error, cacheType, url) in

            })
        } else {
            recipeListCell?.recipeImage.image = #imageLiteral(resourceName: "sampleDish")
        }
        
        return recipeListCell!
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    
    func deleteRecipe(forId id: String) {
        FirebaseManager.shared.deleteRecipe(id: id) { (error) in
            if let _ = error {
                debugPrint("Error deleting recipe")
            } else {
                debugPrint("Recipe deleted")
            }
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipeId = arrRecipe?[indexPath.row].id
            arrRecipe?.remove(at: indexPath.row)
            
            if (arrRecipe?.isEmpty)! {
                tableView.deleteSections(IndexSet([0]), with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

            deleteRecipe(forId: recipeId!)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
