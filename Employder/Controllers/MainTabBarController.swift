//
//  MainTabBarController.swift
//  Employder
//
//  Created by Serov Dmitry on 11.08.22.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {

    private let currentUser: MUser

    // MARK: - init

    init(currentUser: MUser
         = MUser(userName: "lll", avatarStringURL: "lll", description: "lll", email: "lll", id: "lll", sex: "lll")
    ) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        // setups
        tabBar.tintColor = UIColor.purpleMainColor()
        let listImage = UIImage(systemName: "message.fill")!
        let candidatesImage = UIImage(systemName: "person.3.fill")!

        // controllers
        let listViewController = ListViewController(currentUser: currentUser)
        let candidatesViewController = CandidatesViewController()

        viewControllers = [
            generateNavigationController(rootViewController: candidatesViewController,
                                         title: "Знакомства",
                                         image: candidatesImage),
            generateNavigationController(rootViewController: listViewController,
                                         title: "Общение",
                                         image: listImage)
        ]
    }

    // MARK: - generateNavigationController

    private func generateNavigationController(rootViewController: UIViewController,
                                              title: String,
                                              image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
