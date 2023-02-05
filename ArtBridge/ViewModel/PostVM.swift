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
    @Published var posts : [Datum] = []
    @Published var Boards : BoardResponse? = nil
    
    var getSuccess = PassthroughSubject<(), Never>()
    
    //MARK: - 게시판 목록 가져오기 함수
    func fetchPostData() {
        print("PostVM - fetchPostData() called")
        PostApiService.fetchPostData()
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("PostVM completion: \(completion)")
            } receiveValue: { (receivedData: PostData) in
                print("test -> \(receivedData)")
                self.postData = receivedData
                self.posts = receivedData.data
            }.store(in: &subscription)
    }
    
    //MARK: - 게시글 작성 함수
    func createPostData(title: String, contents: String, author: String) {
        print("PostVM - createPostData() called")
        PostApiService.createPostData(title: title, contents: contents, author: author)
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("PostVM createPostData Completion: \(completion)")
            } receiveValue: { (receivedData: PostData) in
                print("TEST chang")
            }.store(in: &subscription)
    }
    
    //MARK: - 게시글 삭제 함수
    func removePostData(id: Int) {
        print("PostVM - removePostData() called")
        PostApiService.removePostData(id: id)
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("PostVM removePostData Completion: \(completion)")
            } receiveValue: { (receivedData: BoardResponse) in
                print("Test Chang")
            }.store(in: &subscription)
    }
    
    //MARK: - 게시글 수정
    func editPostData(title: String, contents: String, author: String,  id: Int) {
        print("PostVM - editPostData() called")
        PostApiService.editPostData(title: title, contents: contents, author: author, id: id)
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("PostVM editPostData Completion: \(completion)")
            } receiveValue: { (receivedData: PostData) in
                print("Test Chang")
            }.store(in: &subscription)
    }
}
