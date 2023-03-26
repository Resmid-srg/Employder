//
//  ChatViewController.swift
//  Employder
//
//  Created by Serov Dmitry on 17.10.22.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SDWebImage
import FirebaseFirestore

class ChatViewController: MessagesViewController {

    // Models
    private var messages: [MMessage] = []
    private let currentUser: MUser
    private let chat: MChat

    // Listeners
    private var messageListener: ListenerRegistration?

    // MARK: - init/deinit

    init(currentUser: MUser, chat: MChat) {
        self.currentUser = currentUser
        self.chat = chat
        super.init(nibName: nil, bundle: nil)

        title = chat.friendUserName
    }

    deinit {
        messageListener?.remove()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegates
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        // Setups
        configureMessageInputBar()

        // Listeners
        messageListener = ListenerService.shared.messagesObserve(chat: chat, completion: { result in
            switch result {
            case .success(let message):
                self.insertNewMessage(message: message)
            case .failure(let error):
                self.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        })
    }

    // MARK: - viewDidAppear

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messagesCollectionView.scrollToLastItem()
    }

    // MARK: - insertNewMessage

    private func insertNewMessage(message: MMessage) {
        guard !messages.contains(message) else { return }
        messages.append(message)
        messages.sort()

        messagesCollectionView.reloadData()
    }

    // MARK: - Configure InputBar

    private func configureMessageInputBar() {
        messageInputBar.delegate = self

        messageInputBar.inputTextView.tintColor = .red
        messageInputBar.sendButton.setTitleColor(.green, for: .normal)
        messageInputBar.sendButton.setTitleColor(UIColor.yellow.withAlphaComponent(0.3), for: .highlighted)
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.tintColor = .blue
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245 / 255,
                                                                green: 245 / 255,
                                                                blue: 245 / 255,
                                                                alpha: 1)

        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6,
                                                                     green: 0.6,
                                                                     blue: 0.6,
                                                                     alpha: 1)

        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8,
                                                                        left: 16,
                                                                        bottom: 8,
                                                                        right: 36)

        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8,
                                                                            left: 20,
                                                                            bottom: 8,
                                                                            right: 36)

        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200 / 255,
                                                                  green: 200 / 255,
                                                                  blue: 200 / 255,
                                                                  alpha: 1).cgColor

        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8,
                                                                           left: 0,
                                                                           bottom: 8,
                                                                           right: 0)
        messageInputBar.inputTextView.layer.borderWidth = 0.2
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        inputBarType = .custom(messageInputBar)
        configureInputBarItems()
    }

    private func configureInputBarItems() {
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.image = UIImage(systemName: "paperplane.fill")?.maskWithColor(color:
                .purpleMainColor())
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 1
        let charCountButton = InputBarButtonItem()
            .configure {
                $0.title = "0/140"
                $0.contentHorizontalAlignment = .right
                $0.setTitleColor(UIColor(white: 0.6, alpha: 1), for: .normal)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
                $0.setSize(CGSize(width: 50, height: 25), animated: false)
            }.onTextViewDidChange { item, textView in
                item.title = "\(textView.text.count)/140"
                let isOverLimit = textView.text.count > 140
                item.inputBarAccessoryView?
                    .shouldManageSendButtonEnabledState = !isOverLimit
                if isOverLimit {
                    item.inputBarAccessoryView?.sendButton.isEnabled = false
                }
                let color = isOverLimit ? .red : UIColor(white: 0.6, alpha: 1)
                item.setTitleColor(color, for: .normal)
            }
        let bottomItems = [.flexibleSpace, charCountButton]
        configureInputBarPadding()
        messageInputBar.setStackViewItems(bottomItems, forStack: .bottom, animated: false)
        messageInputBar.sendButton
            .onEnabled { _ in
                UIView.animate(withDuration: 0.3, animations: {
                })
            }.onDisabled { _ in
                UIView.animate(withDuration: 0.3, animations: {
                })
            }
    }

    private func configureInputBarPadding() {

        messageInputBar.padding.bottom = 0
        messageInputBar.middleContentViewPadding.right = -38
        messageInputBar.inputTextView.textContainerInset.bottom = 8
    }
}

// MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        let userMK = UserMK(senderId: currentUser.id, displayName: currentUser.userName)
        return userMK
    }

    func messageForItem(at indexPath: IndexPath,
                        in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.item]
    }

    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return 1
    }

    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.item % 4 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                                      attributes: [
                                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                                        NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        } else {
            return nil
        }
    }
}

// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        CGSize(width: 0, height: 8)
    }

    func cellTopLabelHeight(for message: MessageType,
                            at indexPath: IndexPath,
                            in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.item % 5 == 0 {
            return 30
        } else {
            return 0
        }
    }
}

// MARK: - MessageDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {

    func backgroundColor(for message: MessageType,
                         at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if isFromCurrentSender(message: message) {
            return .purpleMainColor().withAlphaComponent(0.8)
        } else {
            return .purpleLightColor().withAlphaComponent(0.05)
        }
    }

    func textColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
        isFromCurrentSender(message: message) ? .white : .black
    }

    func configureAvatarView(_ avatarView: AvatarView,
                             for message: MessageType,
                             at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) {
        var avatarString: String

        if isFromCurrentSender(message: message) {
            avatarString = currentUser.avatarStringURL
        } else {
            avatarString = chat.friendUserImageStringURL
        }

        avatarView.sd_setImage(with: URL(string: avatarString))
        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor.purpleLightColor().cgColor
    }

    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
      guard indexPath.item + 1 < messages.count else { return false }
        return messages[indexPath.item].sender.senderId == messages[indexPath.item + 1].sender.senderId
    }

    func messageStyle(for message: MessageType,
                      at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        .bubble
    }
}

// MARK: - InputBarAccessoryViewDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {

    @objc
    func inputBar(_: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MMessage(user: currentUser, content: text)
        processInputBar(messageInputBar, message: message)
        FirestoreService.shared.sendMessage(chat: chat, message: message, completion: { [weak self] result in
            switch result {
            case .success:
                self?.messagesCollectionView.scrollToLastItem()
            case .failure(let error):
                self?.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        })
    }

    func processInputBar(_ inputBar: InputBarAccessoryView, message: MMessage) {
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { _, range, _ in
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "Aa"
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
}

// MARK: - SwiftUI

import SwiftUI

struct ChatVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {

        let chatVC = ChatViewController(currentUser: MUser(userName: "1",
                                                           avatarStringURL: "1",
                                                           description: "1",
                                                           email: "1",
                                                           id: "1",
                                                           sex: "1"),
                                        chat: MChat(friendUserName: "2",
                                                    friendUserImageStringURL: "2",
                                                    lastMessageContent: "2",
                                                    friendId: "2"))

        func makeUIViewController(
            context: UIViewControllerRepresentableContext<ChatVCProvider.ContainerView>) -> ChatViewController {
            return chatVC
        }

        func updateUIViewController(_ uiViewController: ChatVCProvider.ContainerView.UIViewControllerType,
                                    context: UIViewControllerRepresentableContext<ChatVCProvider.ContainerView>) {

        }
    }
}
