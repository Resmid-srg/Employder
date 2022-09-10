//
//  UserErrors.swift
//  Employder
//
//  Created by Serov Dmitry on 11.09.22.
//

import Foundation

enum UserErrors {
    case notFilled
    case photoNotExist
}

extension UserErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .notFilled:
                return NSLocalizedString("Заполните все поля", comment: "")
            case .photoNotExist:
                return NSLocalizedString("Фото не определено", comment: "")
        }
    }
}
