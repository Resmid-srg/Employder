//
//  UIView + Extension.swift
//  Employder
//
//  Created by Serov Dmitry on 31.08.22.
//

import UIKit

extension UIView {

    func applyGradients(cornerRadius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientView = GradientView(fromPoint: .topLeading,
                                        toPoint: .bottomTrailing,
                                        startColor: .gradientColor1(),
                                        endColor: .gradientColor2())
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
            self.layer.insertSublayer(gradientLayer, at: 0)
        }

    }
}
