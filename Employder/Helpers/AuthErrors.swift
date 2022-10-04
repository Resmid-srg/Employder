//
//  AuthErrors.swift
//  Employder
//
//  Created by Serov Dmitry on 05.09.22.
//

import Foundation

enum AuthErrors {
    case notFilled
    case invalidEmail
    case passwordsNotMatches
    case unknownError
    case serverError
}

extension AuthErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Некорректный email", comment: "")
        case .passwordsNotMatches:
            return NSLocalizedString("Пароли не совпадают", comment: "")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        }
    }
}
