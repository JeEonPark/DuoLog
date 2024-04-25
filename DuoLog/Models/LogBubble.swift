//
//  LogBubble.swift
//  DuoLog
//
//  Created by DevJonny on 2024/4/15.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct LogBubble: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var creationDate: Date
    var comments: [Comment]
}

struct Comment: Identifiable, Codable {
    var id: String
    var text: String
    var author: String
}
