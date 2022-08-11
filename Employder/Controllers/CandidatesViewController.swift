//
//  CandidatesViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 11.08.22.
//

import UIKit

class CandidatesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
    }
}

//MARK: - SwiftUI

import SwiftUI

struct CandidatesVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<CandidatesVCProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: CandidatesVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<CandidatesVCProvider.ContainerView>) {
            
        }
    }
}
