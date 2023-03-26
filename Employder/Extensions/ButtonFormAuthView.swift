//
//  ButtonFormAuthView.swift
//  Employder
//
//  Created by Serov Dmitry on 09.08.22.
//

import UIKit

class ButtonFormAuthView: UIView {

    init(label: UILabel, button: UIButton) {
        super.init(frame: .zero)

        // tAMIC
        self.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        // addSubviews
        self.addSubview(label)
        self.addSubview(button)

        // Constaraints
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])

        bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
