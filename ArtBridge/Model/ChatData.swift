//
//  ChatData.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/16.
//

import Foundation

// 말풍선
struct ChatMessage: Codable, Identifiable {
    var id: String
    var content: String
    var senderUid: String
    var timestamp: String
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
    let destinationUrl: String
    let senderUid: String
//    let senderUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "chatUid"
        case destinationUid
        case destinationUserName
        case destinationUrl
        case senderUid
//        case senderUrl
    }
    init() {
        self.id = ""
        self.destinationUid = ""
        self.destinationUrl = ""
        self.destinationUserName = ""
        self.senderUid = ""
    }
}

//사용자
struct ChatUser: Codable{
    var id: String
    var email: String
    var username: String
    var password: String
}
