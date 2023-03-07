//
//  AccountData.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/10.
//

import Foundation

// MARK: - AccountData
struct AccountData: Codable {
    let username, password, email : String
}

struct LoginData: Codable {
    let identifier, password: String
}

struct LoginResponse: Codable {
    let jwt: String
    let user: User
}

// MARK: - User
struct User: Codable {
    let id: Int
    let username, email, provider: String
    let confirmed, blocked: Bool
    let createdAt, updatedAt: String
}

// MARK: - Firebase
struct firesotreUsers: Codable, Identifiable {
    let id: String
    let email: String
    let password: String
    let username: String
    let url: String
    
    // firestoreUses를 초기화할 때 사용 
    init(email: String, username: String, url: String) {
        self.id = UUID().uuidString
        self.email = email
        self.password = ""
        self.username = username
        self.url = url
    }
}
