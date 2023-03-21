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

//사용자
struct ChatUser: Codable{
    var id: String
    var email: String
    var username: String
    var password: String
}
