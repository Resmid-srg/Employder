//
//  MCandidate.swift
//  Employder
//
//  Created by Serov Dmitry on 30.08.22.
//

import UIKit

struct MCandidate: Hashable, Decodable {
    var userName: String
    var avatarStringURL: String
    var experience: Int
    var aboutMe: String
    var id: Int
    var speciality: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MCandidate, rhs: MCandidate) -> Bool {
        return lhs.id == rhs.id
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lowercasedFilter = filter.lowercased()
        return userName.lowercased().contains(lowercasedFilter)

    }
}
