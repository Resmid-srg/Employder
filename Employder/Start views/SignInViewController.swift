//
//  SignInViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 10.08.22.
//

import UIKit

class SignInViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Welcome, master 🙏", font: .avenir26())
    
    let loginWithLabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let needAccLabel = UILabel(text: "Need an account?")
    
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .buttonBlack())
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sing Up", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()
    
    weak var delegate: AuthNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        googleButton.customizeGoogleButton()
        setupConstraints()
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        print(#function)
        AuthService.shared.login(email: emailTextField.text,
                                 password: passwordTextField.text) { (logResult) in
            switch logResult {
            case .success(let user):
                self.showAlert(with: "Успешно", and: "Вы авторизованы!") {
                    FirebaseService.shared.getUserData(user: user) { result in
                        switch result {
                        case .success(_):
                            let mainTabBar = MainTabBarController()
                            mainTabBar.modalPresentationStyle = .fullScreen
                            self.present(mainTabBar, animated: true, completion: nil)
                        case .failure(_):
                            self.present(SetupProfileViewController(currentUser: user), animated: true)
                        }
                    }
                }
            case .failure(let error):
                self.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSingUpVC()
        }
    }
    
}

//MARK: - Setup constraints

extension SignInViewController {
    
    private func setupConstraints() {
        
        let googleButtonView = ButtonFormAuthView(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField],
                                         axis: .vertical,
                                         spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField],
                                            axis: .vertical,
                                            spacing: 0)
        
        let stackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, loginButton],
                                    axis: .vertical,
                                    spacing: 46)
        let bottomStackView = UIStackView(arrangedSubviews: [needAccLabel, signUpButton],
                                          axis: .horizontal,
                                          spacing: 10)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        googleButtonView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(googleButtonView)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        view.addSubview(orLabel)
        
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            googleButtonView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 80),
            googleButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            googleButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            orLabel.topAnchor.constraint(equalTo: googleButtonView.bottomAnchor, constant: 28),
            orLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 28),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 80),
            bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
}

//MARK: - SwiftUI

import SwiftUI

struct SingInVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let signInVC = SignInViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SingInVCProvider.ContainerView>) -> SignInViewController {
            return signInVC
        }
        
        func updateUIViewController(_ uiViewController: SingInVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SingInVCProvider.ContainerView>) {
            
        }
    }
}
