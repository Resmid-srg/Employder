//
//  UILabel + Extension.swift
//  Employder
//
//  Created by Serov Dmitry on 09.08.22.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        
        self.text = text
        self.font = font
    }
}
