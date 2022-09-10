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
    
    func saveProfileWith(id: String, email: String, userName: String?, avatarImageString: String?, description: String?, sex: String?, completion: @escaping (Result<MCandidate, Error>) -> Void) {
        
        guard Validators.isFilled(userName: userName, description: description, sex: sex) else {
            completion(.failure(UserErrors.notFilled))
            return
        }
        
        let mcandidate = MCandidate(userName: userName!,
                                    avatarStringURL: "notExist",
                                    description: description!,
                                    email: email,
                                    id: id,
                                    sex: sex!)
        
        self.userRef.document(mcandidate.id).setData(mcandidate.representation) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(mcandidate))
            }
        }
        
    }
    
}
