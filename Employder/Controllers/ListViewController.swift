//
//  ListViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 11.08.22.
//

import UIKit

struct EChat: Hashable, Decodable {
    var userName: String
    var userImageString: String
    var lastMessage: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: EChat, rhs: EChat) -> Bool {
        return lhs.id == rhs.id
    }
}

class ListViewController: UIViewController {
    
    let activeChats = Bundle.main.decode([EChat].self, from: "activeChats.json")
    let waitingChats = Bundle.main.decode([EChat].self, from: "waitingChats.json")

    enum Section: Int, CaseIterable {
        case activeChats, waitingChats
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, EChat>?
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        reloadData()
        
        
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
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor.purpleLightColor()
        view.addSubview(collectionView)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId2")

        
//        collectionView.delegate = self
//        collectionView.dataSource = self
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, EChat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
                case .activeChats:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
                    cell.backgroundColor = .purple
                    return cell
                case .waitingChats:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId2", for: indexPath)
                    cell.backgroundColor = .systemMint
                    return cell
            }
        })
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, EChat>()
        snapshot.appendSections([.activeChats, .waitingChats])
        snapshot.appendItems(activeChats, toSection: .activeChats)
        snapshot.appendItems(waitingChats, toSection: .waitingChats)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 5, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(64))
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 16, bottom: 0, trailing: 16)
            return section
        }
        return layout
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
//
//extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
//        cell.backgroundColor = .blue
//        cell.layer.borderWidth = 1
//        return cell
//    }
//
//
//}

//MARK: - UISearchBarDelegate

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print (searchText)
    }
    
}

//MARK: - SwiftUI

import SwiftUI

struct ListVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListVCProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: ListVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListVCProvider.ContainerView>) {
            
        }
    }
}
