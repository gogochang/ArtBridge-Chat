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
struct ChatGroup {
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
struct ChatUser {
    var uid: String
    var email: String
    var username: String
    var group: Dictionary<String,String>
    
    init(uid: String, email: String, username: String) {
        self.uid = uid
        self.email = email
        self.username = username
        self.group = [:]
    }
}
