//
//  ProfileViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 31.08.22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let containerView = UIView()
    let userNameLabel = UILabel(text: "Trololo")
    let aboutMeLabel = UILabel(text: "ohhohohohoohohohhohoho")
    let imageView = UIImageView(image: UIImage(named: "human11"), contentMode: .scaleAspectFill)
    let textField = InsertableTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        customizeElements()
        setupConstraints()
        
    }
    
    private func customizeElements() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.numberOfLines = 0
        //textField.borderStyle = .roundedRect
        containerView.backgroundColor = .systemGroupedBackground
        containerView.layer.cornerRadius = 32
        
//        if let button = textField.rightView as? UIButton {
//            button.addTarget(self, action: #selector(@objc sendMessage()), for: .touchUpInside)
//        }
//    }
//    
//    @objc private func sendMessage() {
//        print(#function)
    }
}

extension ProfileViewController {
    
    private func setupConstraints() {
        
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 44),
            userNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            userNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            aboutMeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 16),
            aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

//MARK: - SwiftUI

import SwiftUI

struct ProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let profileVC = ProfileViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProfileVCProvider.ContainerView>) -> ProfileViewController {
            return profileVC
        }
        
        func updateUIViewController(_ uiViewController: ProfileVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProfileVCProvider.ContainerView>) {
            
        }
    }
}
