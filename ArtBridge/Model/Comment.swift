//
//  Comment.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/13.
//

import FirebaseFirestoreSwift
import Firebase

struct Comment: Identifiable, Decodable {
    @DocumentID var id: String?
    let uid: String
    var comment: String
    var likes: Int
    let author: String
    var profileUrl: String
    let timestamp: Timestamp
    
}
