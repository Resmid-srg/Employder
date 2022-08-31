//
//  SelfConfiguringCell.swift
//  Employder
//
//  Created by Serov Dmitry on 28.08.22.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configur<U: Hashable>(with value: U)
}
