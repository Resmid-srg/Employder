//
//  ProfileViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 31.08.22.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    //Models
    private let user: MUser
    
    let containerView = UIView()
    let userNameLabel = UILabel(text: "Trololo")
    let aboutMeLabel = UILabel(text: "ohhohohohoohohohhohoho")
    let imageView = UIImageView(image: UIImage(named: "human11"), contentMode: .scaleAspectFill)
    let textField = InsertableTextField()
        
    //MARK: init
    
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
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setups
        view.backgroundColor = .white
        customizeElements()
        setupConstraints()
        setupKeyboardHidding()
        
    }
    
    //MARK: - Setups
    
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
    
    //MARK: - Buttons
        
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
    } //func sendMessage
}

//MARK: - Keyboard Setups

extension ProfileViewController {
    
    private func setupKeyboardHidding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }
        
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = self.view.convert(currentTextField.frame, from: currentTextField.superview)
        
        let textBoxY = convertedTextFieldFrame.origin.y
        let newFrameY = (textBoxY - keyboardTopY / 1.3) * -1
        self.view.frame.origin.y = newFrameY
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}

//MARK: - Setup constraints

extension ProfileViewController {
    
    private func setupConstraints() {
        
        //addSubviews
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(textField)
        
        //Constarints
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
            containerView.heightAnchor.constraint(equalToConstant: 320)
        ])
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 28),
            userNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            userNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            userNameLabel.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            aboutMeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
