//
//  Configuration.swift
//  PhotoShoot
//
//  Created by Parth on 08/08/17.
//  Copyright © 2017 Solution Analysts. All rights reserved.
//

import UIKit

struct Configuration {
    static let environment: Environment = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            if configuration.range(of: "JMRecipes-Chef") != nil {
                return Environment.Chef
            } else if configuration.range(of: "Debug") != nil {
                return Environment.Debug
            } else if configuration.range(of: "Release") != nil {
                return Environment.Release
            }
        }
        return Environment.Release
    }()
}
