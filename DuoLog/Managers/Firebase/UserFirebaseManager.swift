//
//  UsersManager.swift
//  DuoLog
//
//  Created by DevJonny on 2024/4/16.
//

import SwiftUI
import FirebaseFirestore

class UserFirebaseManager: ObservableObject {
    
    private var db = Firestore.firestore()
    
    func createUser(_ user: UserModel) {
        do {
            try db.collection("Users").document(user.uid).setData(from: user)
            print("User data successfully saved")
        } catch let error {
            print("Error waiting user to Firestore: \(error)")
        }
    }
    
    // 사용자 uid의 document 존재 여부 확인
    func checkUserDocumentExists(uid: String, completion: @escaping (Bool) -> Void) {
        let userDocumentRef = db.collection("Users").document(uid)
        userDocumentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
