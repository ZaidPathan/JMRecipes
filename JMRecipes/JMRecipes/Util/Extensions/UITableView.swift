//
//  UITableView.swift
//  JMRecipes
//
//  Created by Zaid Pathan on 28/12/17.
//  Copyright © 2017 Zaid Pathan. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell(id: String) {
        let cellNib = UINib(nibName: id, bundle: nil)        
        register(cellNib, forCellReuseIdentifier: id)
    }
}
