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
    
//    func googleLogin(completion: @escaping (Result<User, Error>) -> Void) {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//        // Create Google Sign In configuration object.
//        let config = GIDConfiguration(clientID: clientID)
//
//        // Start the sign in flow!
//        GIDSignIn.sharedInstance.signIn(with: config, presenting: MainTabBarController()) { user, error in
//
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard
//                let authentication = user?.authentication,
//                let idToken = authentication.idToken
//            else {
//                return
//            }
//
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                           accessToken: authentication.accessToken)
//
//            Auth.auth().signIn(with: credential) { authResult, error in
//                if let error = error {
//                    let authError = error as NSError
//                    if authError.code == AuthErrorCode.secondFactorRequired.rawValue {
//                    // The user is a multi-factor user. Second factor challenge is required.
//                    let resolver = authError
//                      .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
//                    var displayNameString = ""
//                    for tmpFactorInfo in resolver.hints {
//                      displayNameString += tmpFactorInfo.displayName ?? ""
//                      displayNameString += " "
//                    }
//                    self.showTextInputPrompt(
//                      withMessage: "Select factor to sign in\n\(displayNameString)",
//                      completionBlock: { userPressedOK, displayName in
//                        var selectedHint: PhoneMultiFactorInfo?
//                        for tmpFactorInfo in resolver.hints {
//                          if displayName == tmpFactorInfo.displayName {
//                            selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
//                          }
//                        }
//                        PhoneAuthProvider.provider()
//                          .verifyPhoneNumber(with: selectedHint!, uiDelegate: nil,
//                                             multiFactorSession: resolver
//                                               .session) { verificationID, error in
//                            if error != nil {
//                              print(
//                                "Multi factor start sign in failed. Error: \(error.debugDescription)"
//                              )
//                            } else {
//                              self.showTextInputPrompt(
//                                withMessage: "Verification code for \(selectedHint?.displayName ?? "")",
//                                completionBlock: { userPressedOK, verificationCode in
//                                  let credential: PhoneAuthCredential? = PhoneAuthProvider.provider()
//                                    .credential(withVerificationID: verificationID!,
//                                                verificationCode: verificationCode!)
//                                  let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator
//                                    .assertion(with: credential!)
//                                  resolver.resolveSignIn(with: assertion!) { authResult, error in
//                                    if error != nil {
//                                      print(
//                                        "Multi factor finanlize sign in failed. Error: \(error.debugDescription)"
//                                      )
//                                    } else {
//                                      self.navigationController?.popViewController(animated: true)
//                                    }
//                                  }
//                                }
//                              )
//                            }
//                          }
//                      }
//                    )
//                  } else {
//                    self.showMessagePrompt(error.localizedDescription)
//                    return
//                  }
//                  // ...
//                  return
//                }
//                // User is signed in
//                // ...
//            }
            
//            Auth.auth().signIn(with: credential) { (result, error) in
//                guard let result = result else {
//                    completion(.failure(error!))
//                    return
//                }
//                completion(.success(result.user))
//            }
//        }
//    }
    
    func googleLogin(completion: @escaping (Result<User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: AuthViewController()) { user, error in
            
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
