//
//  ViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 08.08.22.
//

import UIKit
import Firebase
import GoogleSignIn

class AuthViewController: UIViewController {
    
    let logoImageView = UIImageView(image: UIImage(named: "logo"), contentMode: .scaleAspectFit)
    
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .buttonBlack())
    let loginButton = UIButton(title: "Login", titleColor: .buttonRed(), backgroundColor: .white, isShadow: true)
    
    let signUpVC = SignUpViewController()
    let signInVC = SignInViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        googleButton.customizeGoogleButton()
        setupConstraints()
        
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        
        signInVC.delegate = self
        signUpVC.delegate = self
        
        //GIDSignIn.sharedInstance().delegate = self
    }
    
    @objc private func emailButtonTapped() {
        present(signUpVC, animated: true, completion: nil)
    }
    
    @objc private func loginButtonTapped() {
        present(signInVC, animated: true, completion: nil)
    }
    
    @objc private func googleButtonTapped() {
        sign()
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//        let config = GIDConfiguration(clientID: clientID)

//        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
////            guard error == nil else { return }
////            guard let user = user else { return }
//            if let error = error {
//                //completion(.failure(error))
//                return
//            }
//
//            guard
//                let auth = user?.authentication,
//                let idToken = auth.idToken
//            else { return }
//
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: auth.accessToken)
//
//            Auth.auth().signIn(with: credential) { (result, error) in
//                guard let result = result else {
//                    //completion(.failure(error!))
//                    return
//                }
//                //completion(.success(result.user))
//            }
//        }
    }
}

extension AuthViewController: AuthNavigationDelegate {
    func toSingInVC() {
        present(signInVC, animated: true, completion: nil)
    }
    func toSingUpVC() {
        present(signUpVC, animated: true, completion: nil)
    }
}

extension AuthViewController {
    func sign() {
        AuthService.shared.googleLogin() { result in
            switch result {
            case .success(let user):
                FirebaseService.shared.getUserData(user: user) { result in
                    switch result {
                    case .success:
                        self.showAlert(with: "Успешно", and: "Вы авторизованы") {
                            let mainTabBar = MainTabBarController()
                            mainTabBar.modalPresentationStyle = .fullScreen
                            self.present(mainTabBar, animated: true)
                        }
                    case .failure:
                        self.showAlert(with: "Успешно", and: "Вы зарегистрированы") {
                            self.present(SetupProfileViewController(currentUser: user), animated: true)
                        }
                    }
                }
            case .failure(let error):
                self.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
}

//MARK: - Setup constraints

extension AuthViewController {
    
    private func setupConstraints() {
        let googleView = ButtonFormAuthView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormAuthView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormAuthView(label: alreadyOnboardLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView],
                                    axis: .vertical,
                                    spacing: 40)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
    }
}

//MARK: - SwiftUI

import SwiftUI

struct AuthVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = AuthViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<AuthVCProvider.ContainerView>) -> AuthViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: AuthVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AuthVCProvider.ContainerView>) {
            
        }
    }
}
