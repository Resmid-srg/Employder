//
//  FirebaseService.swift
//  Employder
//
//  Created by Serov Dmitry on 09.09.22.
//

import Firebase
import FirebaseFirestore

class FirebaseService {
    
    static let shared = FirebaseService()
    
    let db = Firestore.firestore()
    
    private var userRef: CollectionReference {
        return db.collection("users")
    }
    
    func getUserData (user: User, completion: @escaping (Result<MCandidate, Error>) -> Void) {
        let docRef = userRef.document(user.uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let mcandidate = MCandidate(document: document) else {
                    completion(.failure(UserErrors.cannotConvertToMCandidate))
                    return
                }
                completion(.success(mcandidate))
            } else {
                completion(.failure(UserErrors.cannotGetUserInfo))
            }
        }
    }
    
    func saveProfileWith(id: String, email: String, userName: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<MCandidate, Error>) -> Void) {
        
        guard Validators.isFilled(userName: userName, description: description, sex: sex) else {
            completion(.failure(UserErrors.notFilled))
            return
        }
        
        guard avatarImage != UIImage(named: "avatar") else {
            completion(.failure(UserErrors.photoNotExist))
            return
        }
        
        var mcandidate = MCandidate(userName: userName!,
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
}
