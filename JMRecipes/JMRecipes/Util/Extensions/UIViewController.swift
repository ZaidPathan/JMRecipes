//
//  UIViewController.swift
//  JMRecipes
//
//  Created by Zaid Pathan on 29/12/17.
//  Copyright © 2017 Zaid Pathan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UIViewController {
    func showAlert(title: String?, message: String?,b1Title: String = "OK", onB1Click:(()->())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: b1Title, style: UIAlertActionStyle.default, handler: { (action) in
            onB1Click?()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String?, message: String?, b1Title: String?, b2Title: String? , onB1Click:(()->())?, onB2Click:(()->())?,fistButtonStyle: UIAlertActionStyle = .default, secondButtonStyle: UIAlertActionStyle = .default) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: b1Title, style: fistButtonStyle, handler: { (action) in
            onB1Click?()
        }))
        
        alert.addAction(UIAlertAction(title: b2Title, style: secondButtonStyle, handler: { (action) in
            onB2Click?()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func startLoading() {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        view.addSubview(activity)
        view.bringSubview(toFront: activity)
        
        activity.frame = view.frame
        
        activity.startAnimating()
    }
    
    func stopLoading() {
        for subView in view.subviews {
            if subView.isKind(of: UIActivityIndicatorView.self) {
                subView.removeFromSuperview()
            }
        }
    }
}
