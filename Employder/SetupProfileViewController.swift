//
//  SetupProfileViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 10.08.22.
//

import UIKit

class SetupProfileViewController: UIViewController {
    
    let fullAddPhotoView = AddPhotoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
        
        
    }
}


extension SetupProfileViewController {
    
    private func setupConstraints() {
        
        fullAddPhotoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fullAddPhotoView)
        
        NSLayoutConstraint.activate([
            fullAddPhotoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            fullAddPhotoView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
//MARK: - SwiftUI

import SwiftUI

struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let signInVC = SetupProfileViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) -> SetupProfileViewController {
            return signInVC
        }
        
        func updateUIViewController(_ uiViewController: SetupProfileVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) {
            
        }
    }
}
