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
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .blue
        //navigationController.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }

    
}

//MARK: - UISearchBarDelegate

extension CandidatesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print (searchText)
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
