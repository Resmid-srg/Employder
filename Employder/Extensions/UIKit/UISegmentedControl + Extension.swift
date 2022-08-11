//
//  UISegmentedControl + Extension.swift
//  Employder
//
//  Created by Serov Dmitry on 11.08.22.
//

import UIKit

extension UISegmentedControl {
    
    convenience init(first: String, second: String) {
        self.init()
        self.insertSegment(withTitle: first, at: 0, animated: true)
        self.insertSegment(withTitle: second, at: 1, animated: true)
        self.selectedSegmentIndex = 0
        self.selectedSegmentTintColor = #colorLiteral(red: 0.448291719, green: 0.1095626131, blue: 0.4291127622, alpha: 0.3026679422)
    }
}
