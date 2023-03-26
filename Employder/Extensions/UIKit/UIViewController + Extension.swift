//
//  UIViewController + Extension.swift
//  Employder
//
//  Created by Serov Dmitry on 30.08.22.
//

import UIKit

extension UIViewController {

    func configur<T: SelfConfiguringCell, U: Hashable>(collectionView: UICollectionView,
                                                       cellType: T.Type,
                                                       with value: U,
                                                       for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId,
                                                            for: indexPath) as? T else {
            fatalError("Unable to deque \(cellType)")
        }
        cell.configur(with: value)
        return cell
    }
}
