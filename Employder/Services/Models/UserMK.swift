//
//  UserMK.swift
//  Employder
//
//  Created by Serov Dmitry on 21.10.22.
//

import MessageKit

struct UserMK: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
