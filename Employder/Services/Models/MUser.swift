//
//  MUser.swift
//  Employder
//
//  Created by Serov Dmitry on 30.08.22.
//

import UIKit
import FirebaseFirestore

struct MUser: Hashable, Decodable {
    var userName: String
    var avatarStringURL: String
    var description: String
    var email: String
    var id: String
    var sex: String

    init(userName: String, avatarStringURL: String, description: String, email: String, id: String, sex: String) {
        self.userName = userName
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.email = email
        self.id = id
        self.sex = sex
    }

    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let userName = data["userName"] as? String,
              let avatarStringURL = data["avatarStringURL"] as? String,
              let description = data["description"] as? String,
              let email = data["email"] as? String,
              let id = data["uid"] as? String,
              let sex = data["sex"] as? String else { return nil }

        self.userName = userName
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.email = email
        self.id = id
        self.sex = sex
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let userName = data["userName"] as? String,
              let avatarStringURL = data["avatarStringURL"] as? String,
              let description = data["description"] as? String,
              let email = data["email"] as? String,
              let id = data["uid"] as? String,
              let sex = data["sex"] as? String else { return nil }

        self.userName = userName
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.email = email
        self.id = id
        self.sex = sex
    }

    var representation: [String: Any] {
        var rep = ["userName": userName]
        rep["avatarStringURL"] = avatarStringURL
        rep["description"] = description
        rep["email"] = email
        rep["uid"] = id
        rep["sex"] = sex
        return rep
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MUser, rhs: MUser) -> Bool {
        return lhs.id == rhs.id
    }

    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lowercasedFilter = filter.lowercased()
        return userName.lowercased().contains(lowercasedFilter)

    }
}
