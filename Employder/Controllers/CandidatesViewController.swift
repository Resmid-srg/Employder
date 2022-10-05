//
//  CandidatesViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 11.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CandidatesViewController: UIViewController {
    
    //let users = Bundle.main.decode([MCandidate].self, from: "users.json")
    var users = [MCandidate]()
    
    private var usersListener: ListenerRegistration?
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MCandidate>?
    var collectionView: UICollectionView!
    
    enum Section: Int, CaseIterable {
        case users
        
        func description (usersCount: Int) -> String {
            switch self {
            case .users:
                return "\(usersCount) кандидатов"
            }
        }
    }
    
    deinit {
        usersListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.title = "Кандидаты"
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        
        users.forEach {(userss) in
            print(userss.userName)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(signOut))
        
        usersListener = ListenerService.shared.usersObserve(users: users, completion: { result in
            switch result {
            case .success(let users):
                self.users = users
                self.reloadData(with: nil)
            case .failure(let error):
                self.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        })
    }
    
    @objc private func signOut() {
        let ac = UIAlertController(title: nil, message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        ac.addAction(UIAlertAction(title: "Выйти", style: .default, handler: { _ in
            do {
                try Auth.auth().signOut()
                UIApplication.shared.mainKeyWindow?.rootViewController = AuthViewController()
            } catch {
                print ("Error signing out \(error.localizedDescription)")
            }
        }))
        present(ac, animated: true )
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //collectionView.backgroundColor = UIColor.purpleLightColor()
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(CandidateCell.self, forCellWithReuseIdentifier: CandidateCell.reuseId)
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .white
        //navigationController.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func reloadData(with searchText: String?) {
        let filtered = users.filter { (userss) -> Bool in
            userss.contains(filter: searchText)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MCandidate>()
        snapshot.appendSections([.users])
        snapshot.appendItems(filtered, toSection: .users)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    
}

//MARK: - Data Source

extension CandidatesViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MCandidate>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, userss) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .users:
                return self.configur(collectionView: collectionView, cellType: CandidateCell.self, with: userss, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Can non create new section header") }
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
            let items = self.dataSource?.snapshot().itemIdentifiers(inSection: .users)
            sectionHeader.configure(text: section.description(usersCount: items!.count), font: .systemFont(ofSize: 28, weight: .light), textColor: .label)
            
            return sectionHeader
        }
    }
}

//MARK: - Setup layout

extension CandidatesViewController {
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .users:
                return self.createCandidatesSection()
                
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    private func createCandidatesSection() -> NSCollectionLayoutSection {
        let spacing = CGFloat(16)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = spacing
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return sectionHeader
    }
}

//MARK: - UISearchBarDelegate

extension CandidatesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
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