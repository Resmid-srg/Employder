//
//  UIImage + Extension.swift
//  Employder
//
//  Created by Serov Dmitry on 09.08.22.
//

import UIKit
extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
    
}

