//
//  UserService.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/13.
//

import Foundation
import Firebase

struct UserService {

    //MARK: - 회원가입
    func register(email: String, password: String, username: String, completion: @escaping (Bool) -> Void) {
        print("UserService - register() called")
        
        //Firebase 계정 생성
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("UserService - register() Error \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else { return }
            
            // 기본 Profile Image Url
            let defaultProfileUrl = "https://firebasestorage.googleapis.com/v0/b/my-project-21053.appspot.com/o/images%2Fuser.png?alt=media&token=cf8be2a4-4cbe-4c5d-a1f3-9221cd997adc"
            
            // UserData
            let userData = ["uid": user.uid,
                            "email": email,
                            "username": username,
                            "password": password,
                            "profileUrl": defaultProfileUrl]
            
            // Firestore에 UserData 업로드
            Firestore.firestore().collection("users").document(user.uid)
                .setData(userData) { error in
                    if let error = error {
                        print("UserService - Firestore setData Error \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    print("UserService - register() Success")
                }
            updateUser(username: username, profileUrl: defaultProfileUrl)
            completion(true)
        }
        
    }
    
    //MARK: - 로그인
    func logIn(email: String, password: String, completion: @escaping (Firebase.User) -> Void) {
        print("UserService - logIn() called")
        Auth.auth().signIn(withEmail: email, password: password) { result,error  in
            if let error = error {
                print("UserService - register() Error \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else { return }
            
            print("LogInUser UID : \(user.uid)")
            completion(user)
        }
    }
    
    //MARK: - 로그아웃
    
    //MARK: - Uid로 유저정보 가져오기
    func fetchUser(uid: String, completion: @escaping (User) -> Void) {
        print("UserService - fetchUser() called")
        Firestore.firestore().collection("users").document(uid).getDocument{ snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let user = try? snapshot.data(as: User.self) else { return }
            completion(user)
        }
    }
    
    //MARK: - Firestore 유저 정보 수정
    func editUser(username: String, profileUrl: String) {
        print("UserService - editUser() called")
        guard let user = Auth.auth().currentUser else { return }
        Firestore.firestore().collection("users").document(user.uid)
            .updateData(["username": username,
                         "profileUrl": profileUrl]) { error in
                if let error = error {
                    print("UserService - editUser() Error : \(error.localizedDescription)")
                }
                print("UserService - editUser() Success")
                updateUser(username: username, profileUrl: profileUrl)
            }
    }
    
    //MARK: - 유저 정보 변경
    func updateUser(username: String, profileUrl: String) {
        print("UserService - updateUser() called")
        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
            changeRequest.displayName = username
            changeRequest.photoURL = URL(string: profileUrl)
            changeRequest.commitChanges() { error in
                if let error = error {
                    print("UserService - updateUser() Error: \(error.localizedDescription)")
                    return
                }
                print("UserService - updateUser() success")
            }
        }
    }
}
