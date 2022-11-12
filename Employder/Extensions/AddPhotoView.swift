//
//  AddPhotoView.swift
//  Employder
//
//  Created by Serov Dmitry on 10.08.22.
//

import UIKit

class AddPhotoView: UIView {
    
    let imageView: UIView = {
        let image = UIView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.borderWidth = 1
        return image
    }()
    
    var circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "avatar")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = false
        return imageView
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "plus")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.purpleMainColor()
        return button
    }()
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.addSubview(circleImageView)
        addSubview(plusButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setups constaraints
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        NSLayoutConstraint.activate([
            circleImageView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            circleImageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            circleImageView.widthAnchor.constraint(equalToConstant: 160),
            circleImageView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        NSLayoutConstraint.activate([
            plusButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            plusButton.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.bottomAnchor.constraint(equalTo: circleImageView.bottomAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: plusButton.trailingAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
}
