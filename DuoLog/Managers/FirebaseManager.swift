//
//  FirebaseManager.swift
//  DuoLog
//
//  Created by DevJonny on 2024/4/15.
//

import SwiftUI
import FirebaseFirestore

class FirebaseManager: ObservableObject {
    @Published var logBubbles: [LogBubble] = []
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("logBubbles").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            self.logBubbles = querySnapshot?.documents.compactMap { document in
                try? document.data(as: LogBubble.self)
            } ?? []
        }
    }
}
