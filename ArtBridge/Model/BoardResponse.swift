//
//  BoardResponse.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/05.
//

import Foundation

struct BoardResponse: Codable {
    let data: DataClass
    let meta: MetaResponse
}

// MARK: - DataClass
struct DataClass: Codable {
    let id: Int
    let attributes: AttributesResponse
}

// MARK: - Attributes
struct AttributesResponse: Codable {
    let title, contents, date: String
    let createdAt, updatedAt, publishedAt, author: String?
}

// MARK: - Meta
struct MetaResponse: Codable {
}
