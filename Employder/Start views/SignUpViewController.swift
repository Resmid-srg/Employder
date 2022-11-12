//
//  SignUpViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 10.08.22.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let helloLabel = UILabel(text: "Hello!", font: .avenir26())
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let confirmPasswordLabel = UILabel(text: "Confirm your passowrd")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20(), isSecure: true)
    let confirmPasswordTextField = OneLineTextField(font: .avenir20(), isSecure: true)
    
    let signUpButton = UIButton(title: "Sign Up", titleColor: .white, backgroundColor: .buttonBlack())
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()
    
    //Delegates
    weak var delegate: AuthNavigationDelegate?
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegates
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        //Setups
        view.backgroundColor = .white
        setupConstraints()
        setupKeyboardHidding()
        
        //Buttons
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Buttons
    
    @objc private func signUpButtonTapped() {
        print(#function)
        AuthService.shared.register(email: emailTextField.text,
                                    password: passwordTextField.text,
                                    confirmPassword: confirmPasswordTextField.text) { (authResult) in
            switch authResult {
            case .success(let user):
                self.showAlert(with: "Успешно", and: "Вы зарегистрированы!") {
                    self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                }
            case .failure(let error):
                self.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
    
    @objc private func loginButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSingInVC()
        }
    }
}

//MARK: - Keyboard Setups

extension SignUpViewController {
    
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
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
        
        if textFieldBottomY < keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            self.view.frame.origin.y = newFrameY
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}

//MARK: - showAlert

extension UIViewController {
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAlert = UIAlertAction(title: "Ok", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAlert)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}

//MARK: - Setup constraints

extension SignUpViewController {
    
    private func setupConstraints() {
        
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField],
                                         axis: .vertical,
                                         spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField],
                                            axis: .vertical,
                                            spacing: 0)
        let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordTextField],
                                                   axis: .vertical,
                                                   spacing: 0)
        
        
        let stackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, confirmPasswordStackView, signUpButton],
                                    axis: .vertical,
                                    spacing: 46)
        let bottomStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton],
                                          axis: .horizontal,
                                          spacing: 8)
        
        //tAMIC
        helloLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        //addSubviews
        view.addSubview(helloLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        //Constraints
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        NSLayoutConstraint.activate([
            helloLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 128),
            helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: 88),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 120),
            bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}


//MARK: - SwiftUI

import SwiftUI

struct SingUpVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let signUpVC = SignUpViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SingUpVCProvider.ContainerView>) -> SignUpViewController {
            return signUpVC
        }
        
        func updateUIViewController(_ uiViewController: SingUpVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SingUpVCProvider.ContainerView>) {
        }
    }
}
