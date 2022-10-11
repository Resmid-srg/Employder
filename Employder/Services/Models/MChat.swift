//
//  MChat.swift
//  Employder
//
//  Created by Serov Dmitry on 30.08.22.
//

import UIKit

struct MChat: Hashable, Decodable {
    var friendUserName: String
    var friendUserImageStringURL: String
    var lastMessageContent: String
    var friendId: String
    
    var representation: [String: Any] {
        var rep = ["friendUserName": friendUserName]
        rep["friendUserImageStringURL"] = friendUserImageStringURL
        rep["friendId"] = friendId
        rep["lastMessage"] = lastMessageContent
        return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
