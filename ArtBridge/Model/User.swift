//
//  User.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/10.
//

import FirebaseFirestoreSwift
import Firebase

struct UserTemp: Identifiable, Decodable {
    @DocumentID var id: String?
    let username: String
    let profileImageUrl: String
    let email: String
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == id
    }
}
