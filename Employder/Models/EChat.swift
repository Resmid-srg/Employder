//
//  EChat.swift
//  Employder
//
//  Created by Serov Dmitry on 30.08.22.
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
