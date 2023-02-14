//
//  UserResponse.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/14.
//

import Foundation

struct UserResponse: Codable {
    let jwt: String
    let user: UserData
}

// MARK: - User
struct UserData: Codable {
    let id: Int
    let username, email, provider: String
    let confirmed, blocked: Bool
    let createdAt, updatedAt: String
}

