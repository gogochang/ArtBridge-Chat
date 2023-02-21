//
//  ChatData.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/16.
//

import Foundation

// 말풍선
struct ChatMessage {
    var fromUserId: String
    var text: String
    var timestamp: NSNumber
}

// 채팅방
struct ChatGroup: Identifiable {
    var id = UUID()
    var key: String
    var name: String
    var messages: Dictionary<String, Int>
    
    init(key: String, name: String) {
        self.key = key
        self.name = name
        self.messages = [:]
    }
    
    init(key: String, data: Dictionary<String, AnyObject>) {
        self.key = key
        self.name = data["name"] as! String
        if let messages = data["messages"] as? Dictionary<String, Int> {
            self.messages = messages
        } else {
            self.messages = [:]
        }
    }
}

//MARK: - 채팅방
struct ChatRoom: Codable, Identifiable {
    //TODO: let id: String = "\(UUID())"
    let id: String
    let destinationUid: String
    let destinationUserName: String
    let senderUid: String
    
    enum CodingKeys: String, CodingKey {
        case id = "chatUid"
        case destinationUid
        case destinationUserName
        case senderUid
    }
}

//사용자
struct ChatUser: Codable{
    var id: String
    var email: String
    var username: String
    var password: String
}
