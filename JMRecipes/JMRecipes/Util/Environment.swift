//
//  Environment.swift
//  PhotoShoot
//
//  Created by Parth on 08/08/17.
//  Copyright © 2017 Solution Analysts. All rights reserved.
//

import Foundation

enum Environment: String {
    case Chef = "Chef"
    case Debug = "Debug"
    case Release = "Release"
    
    var name: String {
        switch self {
        case .Chef: return self.rawValue
        case .Debug: return self.rawValue
        case .Release: return self.rawValue
        }
    }
}
