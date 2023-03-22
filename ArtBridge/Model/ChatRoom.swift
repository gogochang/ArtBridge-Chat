//
//  Message.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/21.
//

import FirebaseFirestoreSwift
import Firebase

struct ChatRoom: Identifiable, Decodable {
    @DocumentID var id: String?
    let fromUser: User
    let toUser: User
    var recentMessage: Message?
}
