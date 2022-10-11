//
//  MMessage.swift
//  Employder
//
//  Created by Serov Dmitry on 07.10.22.
//

import UIKit

struct MMessage: Hashable {
    let content: String
    let senderId: String
    let senderUserName: String
    var sentDate: Date
    let id: String?
    
    init(user: MUser, content: String) {
        self.content = content
        senderId = user.id
        senderUserName = user.userName
        sentDate = Date()
        id = nil
    }
    
    var representation: [String: Any] {
        let rep: [String: Any] = [
            "created": sentDate,
            "senderID": senderId,
            "senderName": senderUserName,
            "content": content
            ]
        return rep
    }
}
