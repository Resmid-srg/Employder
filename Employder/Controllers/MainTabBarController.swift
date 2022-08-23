//
//  MainTabBarController.swift
//  Employder
//
//  Created by Serov Dmitry on 11.08.22.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.purpleMainColor()
        
        let listViewController = ListViewController()
        let candidatesViewController = CandidatesViewController()
        
        let listImage = UIImage(systemName: "message.fill")!
        let candidatesImage = UIImage(systemName: "person.3.fill")!
        
        viewControllers = [
            
            generateNavigationController(rootViewController: listViewController, title: "Connections", image: listImage),
            generateNavigationController(rootViewController: candidatesViewController, title: "Candidates", image: candidatesImage)
        
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
