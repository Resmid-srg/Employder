//
//  MChat.swift
//  Employder
//
//  Created by Serov Dmitry on 30.08.22.
//

import UIKit
import FirebaseFirestore

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
    
    init(friendUserName: String, friendUserImageStringURL: String, lastMessageContent: String, friendId: String) {
        self.friendUserName = friendUserName
        self.friendUserImageStringURL = friendUserImageStringURL
        self.lastMessageContent = lastMessageContent
        self.friendId = friendId
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let friendUserName = data["friendUserName"] as? String,
              let friendUserImageStringURL = data["friendUserImageStringURL"] as? String,
              let friendId = data["friendId"] as? String,
              let lastMessageContent = data["lastMessage"] as? String else { return nil }
        
        self.friendUserName = friendUserName
        self.friendUserImageStringURL = friendUserImageStringURL
        self.lastMessageContent = lastMessageContent
        self.friendId = friendId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
