//
//  PostVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/01.
//

import Foundation
import SwiftUI
import Firebase

class PostVM: ObservableObject {

    @Published var didUploadPost = false
    @Published var didEditPost = false
    @Published var posts = [Post]()
    @Published var comments = [Comment]()
    let service = PostService()
    
    @Published var imageUrl: String = ""
    
    // 게시판 주제 선택
    enum PostType {
        case all
        case free
        case question
        
        func isPostTypeMatch(type: String) -> Bool {
            switch self {
            case .all:
                return true
            case .free:
                if (type == "자유") {
                    return true
                } else {
                    return false
                }
            case .question:
                if (type == "질문") {
                    return true
                } else {
                    return false
                }
            }
        }
    }
    
    @Published var postType: PostType = .all
    
    
    init() {
        print("PostVM - init called")
        fetchPosts()
    }
    
    //MARK: - Firebase 게시글 업로드
    func uploadPost(title: String, content: String, postType: String, image: UIImage?) {
        print("PostVM - uploadPost called")
        service.uploadPost(title: title, content: content, postType: postType, image: image) { success in
            if success {
                self.didUploadPost = true
                print("PostVM - uploadPost success")
            } else {
                print("PostVM - uploadPost fail")
            }
        }
    }

    //MARK: - Firebase 게시글 수정
    func editPost(post: Post, title: String, content: String, postType: String, image: UIImage?) {
        service.editPost(post, title: title, content: content, postType: postType, image: image) { imageUrl, success in
            if success {
                print("PostVM - editPost success \(imageUrl)")
                // 가져옴 이미지URL을 저장
                self.imageUrl = imageUrl
                // 게시판 수정완료 트리거
                self.didEditPost = true
            } else {
                print("PostVM - editPost fail")
            }
        }
    }
    
    //MARK: - Firebase 게시글 삭제
    func deletePost(post: Post) {
        service.deletePost(post) { success in
            if success {
                print("PostVM - deletePost success")
            } else {
                print("PostVM - deletePost fail")
            }
        }
    }
    
    //MARK: - Firebase 게시글 가져오기
    func fetchPosts() {
        print("PostVM - fetchPosts called")
        service.fetchPosts { posts in
            for _ in 0 ..< posts.count {
                self.posts = posts
            }
        }
    }
    
    //MARK: - Firebase 게시글 댓글 달기
    func addComment(post: Post, comment: String) {
        print("PostVM - addComment")
        service.addComment(post, comment: comment) { success in
            if success {
                print("PostVM - addComment success")
                self.getComment(post: post)
            } else {
                print("PostVM - addComment fail")
            }
        }
    }
   
    //MARK: - Firebase 게시글 댓글 가져오기
    func getComment(post: Post) {
        service.getComment(post) { comment in
            if comment.count == 0 {
                self.comments = [Comment]()
            } else {
                for _ in 0 ..< comment.count {
                    self.comments = comment
                }
            }
        }
    }
    
    //MARK: - Firebase 게시글 댓글 삭제
    func deleteComment(post: Post, comment: Comment) {
        print("PostVM - deleteComment() called")
        service.deleteComment(post, comment) { success in
            if success {
                print("PostVM - deleteComment() success")
                self.getComment(post: post)
            } else {
                print("PostVM - deleteComment() fail")
            }
        }
    }
    
    //MARK: - Firebase 게시글 댓글 수정
    func editComment(post: Post, comment: Comment, content: String) {
        print("PostVM - editComment() called")
        service.editComment(post, comment, commentText: content) { success in
            if success {
                print("PostVM - editComment() success")
                self.getComment(post: post)
            } else {
                print("PostVM - editComment() fail")
            }
        }
    }
    
}
