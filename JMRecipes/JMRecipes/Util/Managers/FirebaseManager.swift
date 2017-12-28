//
//  FirebaseManager.swift
//  JMRecipes
//
//  Created by Zaid Pathan on 28/12/17.
//  Copyright © 2017 Zaid Pathan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    static let shared = FirebaseManager()
    
    var ref: DatabaseReference!
    
    func configure() {
        ref = Database.database().reference()
    }
}
