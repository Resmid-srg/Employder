//
//  AuthService.swift
//  Employder
//
//  Created by Serov Dmitry on 01.09.22.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class AuthService {

    static let shared = AuthService()
    private let auth = Auth.auth()

    // MARK: - Authorization via email

    func login(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {

        guard let email = email,
              let password = password,
              email != "",
              password != "" else {
            return completion(.failure(AuthErrors.notFilled))
        }

        auth.signIn(withEmail: email, password: password) { logResult, error in
            guard let logResult = logResult else {
                completion(.failure(error!))
                return
            }
            completion(.success(logResult.user))
        }
    }

    // MARK: - Authorization and registration via google

    func googleLogin(completion: @escaping (Result<User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(with: config,
                                        presenting: UIApplication.getTopViewController()!) { user, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard
                let auth = user?.authentication,
                let idToken = auth.idToken
            else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: auth.accessToken)

            Auth.auth().signIn(with: credential) { (result, error) in
                guard let result = result else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(result.user))
            }
        }
    }

    // MARK: - Registration via email

    func register(email: String?, password: String?,
                  confirmPassword: String?,
                  completion: @escaping (Result<User, Error>) -> Void) {

        guard Validators.isFilled(email: email, password: password, confirmPassword: confirmPassword) else {
            return completion(.failure(AuthErrors.notFilled))
        }
        guard password! == confirmPassword! else {
            return completion(.failure(AuthErrors.passwordsNotMatches))
        }
        guard Validators.isSimpleEmail(email!) else {
            return completion(.failure(AuthErrors.invalidEmail))
        }

        auth.createUser(withEmail: email!, password: password!) { authResult, error in
            guard let authResult = authResult else {
                completion(.failure(error!))
                return
            }

            completion(.success(authResult.user))
        }
    }
} // class AuthService
