//
//  RecipeBookTVC.swift
//  JMRecipes
//
//  Created by Zaid Pathan on 28/12/17.
//  Copyright © 2017 Zaid Pathan. All rights reserved.
//

import UIKit

class RecipeBookTVC: UITableViewController {

    @IBOutlet weak var btnAdd: UIButton!
    var arrRecipe: [Recipe]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
    }
    
    private func setupOnLoad() {
        tableView.registerCell(id: Const.Cells.recipeListCell)
        btnAdd.isHidden = (Configuration.environment != .Chef)
        
        arrRecipe = []
        fetchRecipe()
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
        guard let arrRecipe = arrRecipe else {
            return 0
        }
        
        return arrRecipe.isEmpty ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrRecipe = arrRecipe else { return 0 }
        return arrRecipe.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipeListCell = tableView.dequeueReusableCell(withIdentifier: "RecipeListCell", for: indexPath) as? RecipeListCell
        recipeListCell?.recipeTitleLabel.text = arrRecipe?[indexPath.row].title

        return recipeListCell!
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
