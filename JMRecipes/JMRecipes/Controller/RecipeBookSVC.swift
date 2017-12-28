//
//  RecipeBookSVC.swift
//  JMRecipes
//
//  Created by Zaid Pathan on 28/12/17.
//  Copyright © 2017 Zaid Pathan. All rights reserved.
//

import UIKit

class RecipeBookSVC: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension RecipeBookSVC: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
