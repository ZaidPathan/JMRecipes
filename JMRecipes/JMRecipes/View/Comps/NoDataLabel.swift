//
//  NoDataLabel.swift
//
//  Created by Zaid Pathan on 30/10/17.
//

import UIKit

class NoDataLabel {
    class func labelWithTitle(title: String, frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = title
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }
}
