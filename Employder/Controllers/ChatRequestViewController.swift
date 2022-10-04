//
//  ChatRequestViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 01.09.22.
//

import UIKit

class ChatRequestViewController: UIViewController {
    
    let containerView = UIView()
    let userNameLabel = UILabel(text: "Trololo")
    let aboutMeLabel = UILabel(text: "ohhohohohoohohohhohoho")
    let imageView = UIImageView(image: UIImage(named: "human11"), contentMode: .scaleAspectFill)
    let acceptButton = UIButton(title: "Принять", titleColor: .white, backgroundColor: .black, font: .avenir20(), isShadow: false, cornerRadius: 10)
    let denyButton = UIButton(title: "Отклонить", titleColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), backgroundColor: .white, font: .avenir20(), isShadow: false, cornerRadius: 10)
    
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
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 30
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.acceptButton.applyGradients(cornerRadius: 10)
    }
}

//MARK: - Setup constraints

extension ChatRequestViewController {
    
    private func setupConstraints() {
        
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(aboutMeLabel)
        
        let buttonsStackView = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 16)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.distribution = .fillEqually
        containerView.addSubview(buttonsStackView)
        
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
            buttonsStackView.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 24),
            buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
    }
}

//MARK: - SwiftUI

import SwiftUI

struct ChatRequestVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let chatRequestVC = ChatRequestViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ChatRequestVCProvider.ContainerView>) -> ChatRequestViewController {
            return chatRequestVC
        }
        
        func updateUIViewController(_ uiViewController: ChatRequestVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ChatRequestVCProvider.ContainerView>) {
            
        }
    }
}
