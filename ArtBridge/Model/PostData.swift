//
//  PostData.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/01.
//

import Foundation

// MARK: - PostData
struct PostData: Codable{
    let data: [Datum]
    let meta: Meta
}

// MARK: - Datum
struct Datum: Codable, Identifiable {
//    let uuid = UUID()
    let id: Int
    var attributes: Attributes
}

// MARK: - Attributes
struct Attributes: Codable {
    var title, contents, author: String
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


