//
//  PostData.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/01.
//

import Foundation

// MARK: - PostData
struct PostData: Codable {
    let data: [Datum]
    let meta: Meta
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int
    let attributes: Attributes
}

// MARK: - Attributes
struct Attributes: Codable {
    let title, contents, date: String
    let like: Int
    let createdAt, updatedAt, publishedAt: String
}

// MARK: - Meta
struct Meta: Codable {
    let pagination: Pagination
}

// MARK: - Pagination
struct Pagination: Codable {
    let page, pageSize, pageCount, total: Int
}
