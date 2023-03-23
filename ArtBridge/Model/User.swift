//
//  User.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/10.
//

import FirebaseFirestoreSwift
import Firebase

struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    var username: String
    let profileUrl: String
    let uid: String
    let email: String
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == id
    }
}
