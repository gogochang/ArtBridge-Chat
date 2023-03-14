//
//  Post.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/10.
//

import FirebaseFirestoreSwift
import Firebase

struct Post: Identifiable, Decodable {
    @DocumentID var id: String?
    var title: String
    var content: String
    let timestamp: Timestamp
    let uid: String
    let author: String
    var profileUrl: String
    let imageUrl: String
    var likes: Int
    
    var user: User?
    var didLike: Bool? = false
}
