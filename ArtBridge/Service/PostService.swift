//
//  PostService.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/10.
//

import Foundation
import Firebase

//TODO: Struct를 사용하는 명확한 이유 :
struct PostService {
    
    //MARK: - 게시글 올리기
    func uploadPost(title: String, content: String, postType: String, image: UIImage?, completion: @escaping(Bool) -> Void) {
        print("PostService - uploadPost() called")
        guard let user = Auth.auth().currentUser else { return }

        let userData = ["username": user.displayName,
                    "profileUrl":user.photoURL?.absoluteString,
                    "uid":user.uid,
                    "email":user.email]
        
        ImageService.uploadImage(image: image) { imageUrl in
            let data = ["postType": postType,
                        "title": title,
                        "content": content,
                        "likes": 0,
                        "imageUrl": imageUrl,
                        "user":userData,
                        "timestamp": Timestamp(date: Date())] as [String: Any]

            Firestore.firestore().collection("posts").document().setData(data) { error in
                if let error = error {
                    print("PostService - uploadPost() Error : \(error.localizedDescription)")
                    completion(false)
                    return
                }
                print("PostService - uploadPost() upload success")
                
                completion(true)
            }
        }
    }
    
    //MARK: - 게시글 수정하기
    func editPost(_ post: Post, title: String, content: String, postType: String, image: UIImage?, completion: @escaping(String, Bool) -> Void) {
        print("PostService - editPost() call")
        ImageService.uploadImage(image: image) { imageUrl in
            Firestore.firestore().collection("posts").document(post.id!)
                .updateData(["title": title,
                             "content": content,
                             "imageUrl": imageUrl,
                             "postType": postType]) { error in
                    if let error = error {
                        print("PostService - editPost() Error : \(error.localizedDescription)")
                        // 데이터 업데이트가 실패하면 ""와 false
                        completion("",false)
                    }
                    //데이터 업데이트가 성공하면 imageUrl과 true를 보냄
                    completion(imageUrl,true)
                }
        }
    }
    
    //MARK: - 게시글 삭제하기
    func deletePost(_ post:Post, completion: @escaping(Bool) -> Void) {
        print("PostService - deletePost() call")
        Firestore.firestore().collection("posts").document(post.id!)
            .delete() { error in
                if let error = error {
                    print("PostService - deletePost() Error : \(error.localizedDescription)")
                    completion(false)
                }
                completion(true)
            }
    }
    
    //MARK: - 게시글 목록 가져오기
    func fetchPosts(completion: @escaping([Post]) -> Void) {
        print("PostService - fetchPosts() call")
        Firestore.firestore().collection("posts")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                let posts = documents.compactMap({ try? $0.data(as: Post.self)})
                completion(posts)
            }
    }
    
    //MARK: - 게시글 댓글 작성
    func addComment(_ post: Post, comment: String, completion: @escaping (Bool) -> Void) {
        print("PostService - addComment() called")
        guard let user = Auth.auth().currentUser else { return }

        let userData = ["username": user.displayName,
                    "profileUrl":user.photoURL?.absoluteString,
                    "uid":user.uid,
                    "email":user.email]
        
        
        let data = ["comment": comment,
                    "likes": 0,
                    "user": userData,
                    "timestamp": Timestamp(date: Date())] as [String: Any]

        Firestore.firestore().collection("posts").document(post.id!).collection("comment").document()
            .setData(data) { error in
                if let error = error {
                    print("PostService - addComment() Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                print("PostService - addComment() upload success")
                completion(true)
            }
    }
    
    //MARK: - 게시글 댓글 삭제하기
    func deleteComment(_ post: Post,_ comment:Comment, completion: @escaping(Bool) -> Void) {
        print("PostService - deletePost() call -> \(comment.id!)")
        Firestore.firestore().collection("posts").document(post.id!).collection("comment").document(comment.id!)
            .delete() { error in
                if let error = error {
                    print("PostService - deletePost() Error : \(error.localizedDescription)")
                    completion(false)
                }
                completion(true)
            }
    }
    
    //MARK: - 게시글 댓글 가져오기
    func getComment(_ post: Post, completion: @escaping ([Comment]) -> Void) {
        print("PostService - getComment() called")
        Firestore.firestore().collection("posts").document(post.id!).collection("comment")
            .order(by: "timestamp", descending: false)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                let comments = documents.compactMap({ try? $0.data(as: Comment.self)})
                completion(comments)
            }
    }
    
    //MARK: - 게시글 댓글 수정하기
    func editComment(_ post: Post, _ comment: Comment, commentText: String, completion: @escaping(Bool) -> Void) {
        print("PostService - editComment() called")
        Firestore.firestore().collection("posts").document(post.id!).collection("comment").document(comment.id!)
            .updateData(["comment": commentText]) { error in
                if let error = error {
                    print("PostService - editComment() Error : \(error.localizedDescription)")
                    completion(false)
                }
                completion(true)
            }
    }
    
    //TODO: - 게시글 이미지 업로드
//    func uploadImage(documentId: String, image: UIImage, completion: @escaping(String) -> Void) {
//        print("PostService - uploadImage() call")
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        ImageUploader.uploadImage(image: image){ imageUrl in
//            completion(imageUrl)
//        }
//    }
}
