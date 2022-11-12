//
//  FirestoreService.swift
//  Employder
//
//  Created by Serov Dmitry on 09.09.22.
//

import Firebase
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private var userRef: CollectionReference {
        return db.collection("users")
    }
    
    private var waitingChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    
    private var activeChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
    }
    
    var currentUser: MUser!
    
    //MARK: - getUserData from firebase
    
    func getUserData (user: User, completion: @escaping (Result<MUser, Error>) -> Void) {
        let docRef = userRef.document(user.uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let mcandidate = MUser(document: document) else {
                    completion(.failure(UserErrors.cannotConvertToMCandidate))
                    return
                }
                self.currentUser = mcandidate
                completion(.success(mcandidate))
            } else {
                completion(.failure(UserErrors.cannotGetUserInfo))
            }
        }
    }
    
    //MARK: - saveProfileWith (filling out a profile when registrering)
    
    func saveProfileWith(id: String, email: String, userName: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
        
        guard Validators.isFilled(userName: userName, description: description, sex: sex) else {
            completion(.failure(UserErrors.notFilled))
            return
        }
        
        guard avatarImage != UIImage(named: "avatar") else {
            completion(.failure(UserErrors.photoNotExist))
            return
        }
        
        var mcandidate = MUser(userName: userName!,
                               avatarStringURL: "notExist",
                               description: description!,
                               email: email,
                               id: id,
                               sex: sex!)
        
        StorageService.shared.upload(photo: avatarImage!) { result in
            switch result {
            case .success(let url):
                mcandidate.avatarStringURL = url.absoluteString
                self.userRef.document(mcandidate.id).setData(mcandidate.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(mcandidate))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        } //StorageService
    } //saveProfileWith
    
    //MARK: - createWaitigChat and deleteWaitingChat
    
    func createWaitingChat(message: String, receiver: MUser, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = db.collection(["users", receiver.id, "waitingChats"].joined(separator: "/"))
        let messageRef = reference.document(self.currentUser.id).collection("messages")
        
        let message = MMessage(user: currentUser, content: message)
        let chat = MChat(friendUserName: currentUser.userName,
                         friendUserImageStringURL: currentUser.avatarStringURL,
                         lastMessageContent: message.content,
                         friendId: currentUser.id)
        
        reference.document(currentUser.id).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageRef.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                }
                completion(.success(Void()))
            }
        }
    }
    
    func deleteWaitingChat(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        waitingChatsRef.document(chat.friendId).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            self.deleteMessages(chat: chat, completion: completion)
        }
    }
    
    //MARK: - deleteMessages
    
    func deleteMessages(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = waitingChatsRef.document(chat.friendId).collection("messages")
        
        getWaitingChatMessages(chat: chat) { result in
            switch result {
            case .success(let messages):
                for message in messages {
                    guard let documentID = message.id else { return }
                    let messageRef = reference.document(documentID)
                    messageRef.delete { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - getWaitingChatMessages
    
    func getWaitingChatMessages(chat: MChat, completion: @escaping (Result<[MMessage], Error>) -> Void ) {
        let reference = waitingChatsRef.document(chat.friendId).collection("messages")
        var messages = [MMessage]()
        reference.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                guard let message = MMessage(document: document) else { return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
    //MARK: - changeToActive and createActiveChat
    
    func changeToActive(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void ) {
        getWaitingChatMessages(chat: chat) { resultGWCM in
            switch resultGWCM {
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { resultDWC in
                    switch resultDWC {
                    case .success:
                        self.createActiveChat(chat: chat, messages: messages) { resultCAC in
                            switch resultCAC {
                            case .success:
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
        
    func createActiveChat(chat: MChat, messages: [MMessage], completion: @escaping (Result<Void, Error>) -> Void ) {
        let messagesRef = activeChatsRef.document(chat.friendId).collection("messages")
        activeChatsRef.document(chat.friendId).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            for message in messages {
                messagesRef.addDocument(data: message.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
    
    //MARK: - sendMessage
    
    func sendMessage(chat: MChat, message: MMessage, completion: @escaping (Result<Void, Error>) -> Void) {
        let friendRef = userRef.document(chat.friendId).collection("activeChats").document(currentUser.id)
        let friendMessagesRef = friendRef.collection("messages")
        let myMessagesRef = userRef.document(currentUser.id).collection("activeChats").document(chat.friendId).collection("messages")
        
        let chatForFriend = MChat(friendUserName: currentUser.userName, friendUserImageStringURL: currentUser.avatarStringURL, lastMessageContent: message.content, friendId: currentUser.id)
        
        friendRef.setData(chatForFriend.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            friendMessagesRef.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                myMessagesRef.addDocument(data: message.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
} //class FirestoreService
