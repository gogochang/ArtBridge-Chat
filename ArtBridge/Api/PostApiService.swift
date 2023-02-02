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
    
    static func fetchPostData() -> AnyPublisher<PostData, AFError> {
        print("PostApiService - fetchPostData() called")
        
        return ApiClient.shared.session
            .request(PostRouter.loadPostData)
            .publishDecodable(type:PostData.self)
            .value()
            .map{ receivedValue in
                print("chang start -> \(receivedValue) chang end")
                return receivedValue
            }.eraseToAnyPublisher()
    }
}
