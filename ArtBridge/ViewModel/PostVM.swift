//
//  PostVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/01.
//

import Foundation
import Alamofire
import Combine

class PostVM: ObservableObject {

    var subscription = Set<AnyCancellable>()

    @Published var postData: PostData? = nil
    @Published var posts : [PostData] = []
    
    // 게시판 목록 가져오기 함수
    func fetchPostData() {
        print("PostVM - fetchPostData() called")
        PostApiService.fetchPostData()
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("PostVM completion: \(completion)")
            } receiveValue: { (receivedData: PostData) in
                print("test -> \(receivedData)")
                self.postData = receivedData
            }.store(in: &subscription)
    }
}
