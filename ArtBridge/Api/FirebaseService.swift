//
//  FirebaseService.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/17.
//

import Foundation
import Firebase

fileprivate let db = Firestore.firestore()

enum FirebaseService {
    
    //MARK: - 로그인
    static func logIn(email: String, password: String, completion: @escaping() -> Void) {
        print("FirebaseService - logIn() called")
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else { return }
            
            print("LogInUser UID : \(user.uid)")
            completion()
        }
    }
    
    //MARK: - 로그아웃
    static func logOut(completion: @escaping() -> Void) {
        print("FirebaseService - logOut() called")
        if let data = try? Auth.auth().signOut() {
            print("FirebaseService - logOut() called \(data)")
            completion()
        }
    }
    
    //MARK: - 회원가입, 가입하는 유저정보를 Firestore에 저장
    static func registerUser(userName: String, email: String, password: String, completion: @escaping () -> Void) {
        print("FirebaseService - registerUser() called")
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                let db = Firestore.firestore()
                
                db.collection("users").document(result!.user.uid)
                    .setData(["id":result?.user.uid,
                              "email": email,
                              "password": password,
                              "username": userName])

                completion()
            }
        }
    }
    
    //MARK: - 현재 유저 가져오기
    static func getCurrentUser() -> Firebase.User? {
        print("FirebaseService - getCurrentUser() called")
        let user = Auth.auth().currentUser
        return user
    }
    
    //MARK: - 모든 유저목록 가져오기
    static func getAllUsers(completion: @escaping ([firesotreUsers]) -> Void) {
        db.collection("users").getDocuments() { (querySnapshot, error) in
            var roadInfos: [firesotreUsers] = []
            if let error = error {
                print("error: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else { return }
                let decoder = JSONDecoder()
                for document in documents {
                    do {
                        let data = document.data()
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let roadInfo = try decoder.decode(firesotreUsers.self, from: jsonData)
                        roadInfos.append(roadInfo)
                    } catch let error {
                        print("err \(error)")
                    }
                }
                completion(roadInfos)
            }
        }
    }
    //MARK: - 채팅방 만들기
    static func createChatRoom(destinationUserUid: String) {
        print("FirebaseService - createChatRoom() called")
        if let uid = getCurrentUser()?.uid {
            //TODO: - ChatData Struct내부에서 UUID정의
            let chatUID = "CHAT-\(UUID())"
            getUserWithUid(destinationUid: destinationUserUid, completion: { username in
                db.collection("users")
                    .document("\(uid)")
                    .collection("groups")
                    .document(chatUID)
                    .setData(["chatUid":"\(chatUID)",
                              "destinationUid":"\(destinationUserUid)",
                              "destinationUserName":"\(username)",
                              "senderUid":"\(uid)"]) })
        }
    }
    
    //MARK: - 현재 유저의 채팅방 리스트 가져오기
    static func fetchChatRoomList(completion: @escaping ([ChatRoom]) -> Void) {
        if let uid = getCurrentUser()?.uid {
            db.collection("users").document("\(uid)").collection("groups").getDocuments() { (querySnapshot, error) in
                var roadInfos: [ChatRoom] = []
                
                if let error = error {
                    print("error: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else { return }
                    let decoder = JSONDecoder()
                    
                    for document in documents {
                        do {
                            let data = document.data()
                            let jsonData = try JSONSerialization.data(withJSONObject: data)
                            let roadInfo = try decoder.decode(ChatRoom.self, from: jsonData)
                            roadInfos.append(roadInfo)
                            print(roadInfos)
                        } catch let error {
                            print("err \(error)")
                        }
                    }
                    completion(roadInfos)
                }
            }
        }
    }
    //MARK: - UID로 유저 이름 가져오기
    static func getUserWithUid(destinationUid: String, completion: @escaping (String) -> Void){
        
        db.collection("users").document("\(destinationUid)").getDocument {
            documentSnapshot, error in
            
            if let error = error {
                print("Error: \(error)")
            } else {
                
                guard let documents = documentSnapshot?.data() else { return }
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try JSONSerialization.data(withJSONObject: documents)
                    let roadInfo = try decoder.decode(ChatUser.self, from: jsonData)
                    completion(roadInfo.username)
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
}
