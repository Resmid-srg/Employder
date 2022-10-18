//
//  ChatViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 17.10.22.
//

import UIKit
import MessageKit

struct UserMK: SenderType, Equatable {
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    
    private var messages: [MMessage] = []
    
    private let user: MUser
    private let chat: MChat
        
    init(user: MUser, chat: MChat) {
        self.user = user
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
                
        title = chat.friendUserName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageInputBar()
    }
    
    func configureMessageInputBar() {
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.placeholderTextColor = .gray
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 1)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 1)
        messageInputBar.inputTextView.layer.borderColor = .init(gray: 1, alpha: 0.5)
        messageInputBar.inputTextView.layer.borderWidth = 0.2
        messageInputBar.inputTextView.layer.cornerRadius = 18.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        
        messageInputBar.layer.shadowColor = .init(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 1, alpha: 1)
        messageInputBar.layer.shadowRadius = 5
        messageInputBar.layer.shadowOpacity = 0.3
        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        configureSentButton()
    }
    
    func configureSentButton() {
        //var configuration = messageInputBar.sendButton.Configuration.filled()
        //configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        messageInputBar.sendButton.setImage(UIImage(named: "send"), for: .normal)
        messageInputBar.sendButton.applyGradients(cornerRadius: 10)
        messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
        messageInputBar.input = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
        //messageInputBar.sendButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 80.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
        messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
        messageInputBar.middleContentViewPadding.right = -38
    }
}

extension ChatViewController: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        let userMK = UserMK(senderId: user.id, displayName: user.userName)
        return userMK
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.item]
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return 1
    }
    
}



//MARK: - SwiftUI

import SwiftUI

struct ChatVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let chatVC = ChatViewController(user: MUser(userName: "1", avatarStringURL: "1", description: "1", email: "1", id: "1", sex: "1"), chat: MChat(friendUserName: "2", friendUserImageStringURL: "2", lastMessageContent: "2", friendId: "2"))
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ChatVCProvider.ContainerView>) -> ChatViewController {
            return chatVC
        }
        
        func updateUIViewController(_ uiViewController: ChatVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ChatVCProvider.ContainerView>) {
            
        }
    }
}
