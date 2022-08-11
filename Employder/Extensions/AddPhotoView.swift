//
//  AddPhotoView.swift
//  Employder
//
//  Created by Serov Dmitry on 10.08.22.
//

import UIKit

class AddPhotoView: UIView {
    
    let imageView1: UIView = {
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
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
//        imageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        imageView.layer.borderWidth = 1
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView1)
        imageView1.addSubview(circleImageView)
        //addSubview(circleImageView)
        addSubview(plusButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imageView1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            imageView1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            imageView1.widthAnchor.constraint(equalToConstant: 100),
            imageView1.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            circleImageView.centerXAnchor.constraint(equalTo: imageView1.centerXAnchor),
            circleImageView.centerYAnchor.constraint(equalTo: imageView1.centerYAnchor),
            circleImageView.widthAnchor.constraint(equalToConstant: 80),
            circleImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            plusButton.centerYAnchor.constraint(equalTo: imageView1.centerYAnchor),
            plusButton.leadingAnchor.constraint(equalTo: imageView1.trailingAnchor, constant: 16),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.bottomAnchor.constraint(equalTo: circleImageView.bottomAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: plusButton.trailingAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView1.layer.masksToBounds = true
        imageView1.layer.cornerRadius = imageView1.frame.width / 2
    }
}
