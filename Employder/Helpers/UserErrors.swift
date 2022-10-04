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
    case cannotGetUserInfo
    case cannotConvertToMCandidate
}

extension UserErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Фото не определено", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Невозможно получить информацию о пльзователе из Firebase", comment: "")
        case .cannotConvertToMCandidate:
            return NSLocalizedString("Невозможно конвертировать MCandidate из User", comment: "")
        }
    }
}
