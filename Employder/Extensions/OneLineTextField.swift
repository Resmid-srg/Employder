//
//  OneLineTextField.swift
//  Employder
//
//  Created by Serov Dmitry on 10.08.22.
//

import UIKit

class OneLineTextField: UITextField {
    
    convenience init(font: UIFont?) {
        self.init()
        
        self.font = font
        self.borderStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var bottomView = UIView()
        bottomView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        bottomView.backgroundColor = .lightGray
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomView)

        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: self.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
