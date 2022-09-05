//
//  AuthService.swift
//  Employder
//
//  Created by Serov Dmitry on 01.09.22.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthService {
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    
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
    
    func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<User, Error>) -> Void) {
        
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
}
