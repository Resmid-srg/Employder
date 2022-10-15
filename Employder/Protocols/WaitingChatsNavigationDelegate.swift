//
//  WaitingChatsNavigationDelegate.swift
//  Employder
//
//  Created by Serov Dmitry on 16.10.22.
//

import Foundation

protocol WaitingChatsNavigationDelegate: AnyObject {
    func removeWaitingChats(chat: MChat)
    func changeToActive(chat: MChat)
}
