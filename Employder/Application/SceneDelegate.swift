//
//  SceneDelegate.swift
//  Employder
//
//  Created by Serov Dmitry on 08.08.22.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = AuthViewController()

        if let user = Auth.auth().currentUser {
            FirestoreService.shared.getUserData(user: user) { result in
                switch result {
                case .success(let mcandidate):
                    let mainTabBar = MainTabBarController(currentUser: mcandidate)
                    mainTabBar.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController = mainTabBar
                case .failure:
                    self.window?.rootViewController = AuthViewController()
                }
            }
        } else {
            window?.rootViewController = AuthViewController()
        }
        window?.makeKeyAndVisible()
    }
}

extension UIApplication {
    var mainKeyWindow: UIWindow? {
        get {
            if #available(iOS 13, *) {
                return connectedScenes
                    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                    .first { $0.isKeyWindow }
            } else {
                return keyWindow
            }
        }
        set {
            if let ader = newValue {
                print("setter \(ader)")
            }
        }
    }
}
