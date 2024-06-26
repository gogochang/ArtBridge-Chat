//
//  ProfileVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/20.
//

import Foundation
import Firebase

class ProfileVM: ObservableObject {
    let userService = UserService()
    
    //프로필 표시 할 유저 정보
    @Published var userProfile: User?
    
    //프로필 표시 할 UID
    @Published var uid: String?
    
    // 유저 정보를 가져와서 userProfile에 저장
    func fetchUser() {
        print("UserVM - fetchUser() called")
        guard let uid = uid else{ return }
        userService.fetchUser(uid: uid) { user in
            self.userProfile = user
        }
    }
    
    //채팅 만들기
    func createChat() {
        print("ProfileVM - createChat() called")
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let chatPartner = userProfile else { return }
        
        let fromUser = ["username":currentUser.displayName,
                        "profileUrl":currentUser.photoURL?.absoluteString,
                        "uid":currentUser.uid,
                        "email":currentUser.email]
        
        let toUser = ["username":chatPartner.username,
                      "profileUrl":chatPartner.profileUrl,
                      "uid":chatPartner.uid,
                      "email":chatPartner.email]
        
        let fromData = ["fromUser": fromUser,
                    "toUser":toUser]
        
        let toData = ["fromUser": toUser,
                      "toUser":fromUser]
        
        let currentUserRef = Firestore.firestore().collection("users").document(currentUser.uid)
            .collection("chats").document(chatPartner.uid)
        
        let chatPartnerRef = Firestore.firestore().collection("users").document(chatPartner.uid)
            .collection("chats").document(currentUser.uid)
        
        currentUserRef.setData(fromData, merge: true)
        chatPartnerRef.setData(toData, merge: true)
    }
    
    // 유저 정보 업데이트
    func updateUser() {
        print("ProfileVM -updateUser() called")
        guard let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() else { return }
        guard let userProfile = userProfile else { return }
    
        let data = ["username": userProfile.username,
                    "profileUrl": userProfile.profileUrl]
        
        changeRequest.displayName = userProfile.username
        changeRequest.photoURL = URL(string: userProfile.profileUrl)
        
        //Auth 업데이트
        changeRequest.commitChanges { error in
            if let error = error {
                print("ProfileVM -updateUser() Error: \(error.localizedDescription)")
                return
            }
        }
        //Firestore 계정 업데이트
        Firestore.firestore().collection("users").document(userProfile.uid).updateData(data) { error in
            if let error = error {
                print("ProfileVM -updateUser() Error: \(error.localizedDescription)")
                return
            }
        }
        
        //게시글의 유저정보 업데이트
        if let posts = userProfile.posts {
            for i in 0 ..< posts.count {
                Firestore.firestore().collection("posts").document(posts[i]).updateData(["user":["username":userProfile.username,
                                                                                              "profileUrl":userProfile.profileUrl,
                                                                                              "email":userProfile.email,
                                                                                              "uid":userProfile.uid]])
            }
        }
        
        let commentRef = Firestore.firestore().collection("posts")
        commentRef.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            for i in 0 ..< documents.count {
                print("changgyu0 -> \(documents[i].documentID)")
                commentRef.document(documents[i].documentID).collection("comment")
                    .whereField("uid", isEqualTo: userProfile.uid)
                    .getDocuments { snapshot, error in
                        guard let commentDocs = snapshot?.documents else { return }
                        
                        for j in 0 ..< commentDocs.count {
                            print("changgyu1 -> \(commentDocs[j])")
                            commentRef.document(documents[i].documentID).collection("comment").document(commentDocs[j].documentID)
                                .setData(["user":["email":userProfile.email,
                                                  "profileUrl":userProfile.profileUrl,
                                                  "uid":userProfile.uid,
                                                  "username":userProfile.username]],merge: true)


                        }
                                                
                    }
            }
        }
        // 게시글의 댓글 유저정보 업데이트
//        let postRef = Firestore.firestore().collection("posts")
//        postRef.getDocuments { snapshot, _ in
//            guard let documents = snapshot?.documents else { return }
//            for i in 0 ..< documents.count {
//
//
//                postRef.document(documents[i].documentID).collection("comment")
//                    .whereField("uid", isEqualTo: userProfile.uid)
//                    .getDocuments { snapshot, error in
//                        if let error = error {
//                            print("Error : \(error.localizedDescription)")
//                        }
//                        guard let commentDocs = snapshot?.documents else { return }
//                        for i in 0 ..< commentDocs.count {
//
//                            postRef.document(documents[i].documentID).collection("comment").document(commentDocs[i].documentID)
//                                .setData(["user":["email":userProfile.email,
//                                                  "profileUrl":userProfile.profileUrl,
//                                                  "uid":userProfile.uid,
//                                                  "username":userProfile.username]],merge: true)
//                        }
//
//                    }
//            }
//        }
    }
}
