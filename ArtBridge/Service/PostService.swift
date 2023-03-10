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
    func uploadPost(title: String, content: String, image: UIImage?, completion: @escaping(Bool) -> Void) {
        print("PostService - uploadPost() called")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if let image = image {
            ImageUploader.uploadImage(image: image) { imageUrl in
                let data = ["uid": uid,
                            "title": title,
                            "content": content,
                            "likes": 0,
                            "author": "anonymous",
                            "imageUrl": imageUrl,
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
        } else {
            let data = ["uid": uid,
                        "title": title,
                        "content": content,
                        "likes": 0,
                        "author": "anonymous",
                        "imageUrl": "",
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
    func editPost(_ post: Post, title: String, content: String, completion: @escaping(Bool) -> Void) {
        print("PostService - editPost() call")
        Firestore.firestore().collection("posts").document(post.id!)
            .updateData(["title": title,
                         "content": content]) { error in
                if let error = error {
                    print("PostService - editPost() Error : \(error.localizedDescription)")
                    completion(false)
                }
                completion(true)
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
    
    //TODO: - 게시글 이미지 업로드
//    func uploadImage(documentId: String, image: UIImage, completion: @escaping(String) -> Void) {
//        print("PostService - uploadImage() call")
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        ImageUploader.uploadImage(image: image){ imageUrl in
//            completion(imageUrl)
//        }
//    }
}
