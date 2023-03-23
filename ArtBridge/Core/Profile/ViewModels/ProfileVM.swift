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
        
        changeRequest.commitChanges { error in
            if let error = error {
                print("ProfileVM -updateUser() Error: \(error.localizedDescription)")
                return
            }
        }
        Firestore.firestore().collection("users").document(userProfile.uid).updateData(data) { error in
            if let error = error {
                print("ProfileVM -updateUser() Error: \(error.localizedDescription)")
                return
            }
        }
    }
}
