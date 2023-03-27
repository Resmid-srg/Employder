//
//  ViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 08.08.22.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseCore

class AuthViewController: UIViewController {

    let logoImageView = UIImageView(image: UIImage(named: "logo"), contentMode: .scaleAspectFit)

    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    let textField1 = UITextField()

    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .buttonBlack())
    let loginButton = UIButton(title: "Login", titleColor: .buttonRed(), backgroundColor: .white, isShadow: true)

    let signUpVC = SignUpViewController()
    let signInVC = SignInViewController()

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setups
        view.backgroundColor = .white
        googleButton.customizeGoogleButton()
        setupConstraints()

        // Buttons
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)

        // Delgates
        signInVC.delegate = self
        signUpVC.delegate = self
    }

    // MARK: - Buttons

    @objc private func emailButtonTapped() {
        present(signUpVC, animated: true, completion: nil)
    }

    @objc private func loginButtonTapped() {
        present(signInVC, animated: true, completion: nil)
    }

    @objc private func googleButtonTapped() {
        AuthService.shared.googleLogin { [weak self] logResult in
            switch logResult {
            case .success(let user):
                self?.showAlert(with: "Успешно", and: "Вы авторизованы!") {
                    FirestoreService.shared.getUserData(user: user) { result in
                        switch result {
                        case .success(let mcandidate):
                            let mainTabBar = MainTabBarController(currentUser: mcandidate)
                            mainTabBar.modalPresentationStyle = .fullScreen
                            self?.present(mainTabBar, animated: true, completion: nil)
                        case .failure:
                            self?.present(SetupProfileViewController(currentUser: user), animated: true)
                        }
                    }
                }
            case .failure(let error):
                self?.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
}

// MARK: - AuthNavigationDelegate

extension AuthViewController: AuthNavigationDelegate {

    func toSingInVC() {
        present(signInVC, animated: true, completion: nil)
    }

    func toSingUpVC() {
        present(signUpVC, animated: true, completion: nil)
    }
}

// MARK: - Keyboard setups

extension AuthViewController {

    private func setupKeyboardHidding() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }

        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height

        if textFieldBottomY > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}

// TODO: Method google authorization with escaping completion
// extension AuthViewController {
//    private func sign() {
//        AuthService.shared.googleLogin() { googleLoginResult in
//            switch googleLoginResult {
//            case .success(let user):
//                FirebaseService.shared.getUserData(user: user) { getUserResult in
//                    switch getUserResult {
//                    case .success:
//                        self.showAlert(with: "Успешно", and: "Вы авторизованы") {
//                            let mainTabBar = MainTabBarController()
//                            mainTabBar.modalPresentationStyle = .fullScreen
//                            self.present(mainTabBar, animated: true)
//                        }
//                    case .failure:
//                        self.showAlert(with: "Успешно", and: "Вы зарегистрированы") {
//                            self.present(SetupProfileViewController(currentUser: user), animated: true)
//                        }
//                    }
//                }
//            case .failure(let error):
//                self.showAlert(with: "Ошибка", and: error.localizedDescription)
//            }
//        }
//    }
// }

// MARK: - Setup constraints

extension AuthViewController {

    private func setupConstraints() {
        let googleView = ButtonFormAuthView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormAuthView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormAuthView(label: alreadyOnboardLabel, button: loginButton)
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView, textField1],
                                    axis: .vertical,
                                    spacing: 40)

        // tAMIC
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // addSubviews
        view.addSubview(logoImageView)
        view.addSubview(stackView)

        // Constraints
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
    }
}

// MARK: - SwiftUI

import SwiftUI

struct AuthVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {

        let viewController = AuthViewController()

        func makeUIViewController(
            context: UIViewControllerRepresentableContext<AuthVCProvider.ContainerView>) -> AuthViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: AuthVCProvider.ContainerView.UIViewControllerType,
                                    context: UIViewControllerRepresentableContext<AuthVCProvider.ContainerView>) {

        }
    }
}
