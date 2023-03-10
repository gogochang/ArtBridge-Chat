//
//  PostApiService.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/01.
//

import Foundation
import Alamofire
import Combine

enum PostApiService {
    
//    static func fetchPostData() -> AnyPublisher<PostData, AFError> {
//        print("PostApiService - fetchPostData() called")
//        
//        return ApiClient.shared.session
//            .request(PostRouter.loadPostData)
//            .publishDecodable(type:PostData.self)
//            .value()
//            .map{ receivedValue in
//                return receivedValue
//            }.eraseToAnyPublisher()
//    }
//    
//    static func createPostData(title: String, contents: String, author: String) -> AnyPublisher<PostData, AFError> {
//        print("PostApiService - createPostData() called")
//        
//        return ApiClient.shared.session
//            .request(PostRouter.createPostData(title: title, contents: contents, author: author))
//            .publishDecodable(type:PostData.self)
//            .value()
//            .map{ receivedValue in
//                return receivedValue
//            }.eraseToAnyPublisher()
//    }
//    
//    static func removePostData(id: Int) -> AnyPublisher<BoardResponse, AFError> {
//        print("PostApiService - removePostData() called")
//        
//        return ApiClient.shared.session
//            .request(PostRouter.removePostData(id: id))
//            .publishDecodable(type: BoardResponse.self)
//            .value()
//            .map{ receivedValue in
//                return receivedValue
//            }.eraseToAnyPublisher()
//    }
//    
//    static func editPostData(title: String, contents: String, author: String,  id: Int) -> AnyPublisher<PostData, AFError> {
//        print("PostApiService - editPostData() called")
//        
//        return ApiClient.shared.session
//            .request(PostRouter.editPostData(title: title, contents: contents, author: author, id: id))
//            .publishDecodable(type: PostData.self)
//            .value()
//            .map{ receivedValue in
//                return receivedValue
//            }.eraseToAnyPublisher()
//    }
}
