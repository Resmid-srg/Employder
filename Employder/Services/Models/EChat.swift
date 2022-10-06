//
//  EChat.swift
//  Employder
//
//  Created by Serov Dmitry on 30.08.22.
//

import UIKit

struct EChat: Hashable, Decodable {
    var friendUserName: String
    var friendUserImageStringURL: String
    var lastMessageContent: String
    var friendId: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: EChat, rhs: EChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
