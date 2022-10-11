//
//  ProfileViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 31.08.22.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    let containerView = UIView()
    let userNameLabel = UILabel(text: "Trololo")
    let aboutMeLabel = UILabel(text: "ohhohohohoohohohhohoho")
    let imageView = UIImageView(image: UIImage(named: "human11"), contentMode: .scaleAspectFill)
    let textField = InsertableTextField()
    
    private let user: MUser
    
    init(user: MUser) {
        self.user = user
        self.userNameLabel.text = user.userName
        self.aboutMeLabel.text = user.description
        self.imageView.sd_setImage(with: URL(string: user.avatarStringURL))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        containerView.backgroundColor = .systemGroupedBackground
        containerView.layer.cornerRadius = 32
        
        if let button = textField.rightView as? UIButton {
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
    }
    
    @objc private func sendMessage() {
        print(#function)
        guard let message = textField.text, message != "" else { return }
        
        
        self.dismiss(animated: true) {
            FirestoreService.shared.createWaitingChat(message: message, receiver: self.user) { result in
                switch result {
                case .success:
                    UIApplication.getTopViewController()?.showAlert(with: "Успешно", and: "Ваше сообщение для \(self.user.userName) было отправлено")
                case .failure(let error):
                    UIApplication.getTopViewController()?.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
        }
    }
    
    
    
}

//MARK: - Setup constraints

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
