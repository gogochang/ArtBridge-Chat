//
//  FirebaseService.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/17.
//

import Foundation
import FirebaseStorage
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
    static func registerUser(userName: String, email: String, password: String, url: String, completion: @escaping () -> Void) {
        print("FirebaseService - registerUser() called")
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                // 이미 계정이 만들어져 있으면 로그인 시도
                print("FirebaseService - registerUser Error: \(error)")
                self.logIn(email: email, password: password, completion: {
                    completion()
                })
            } else {
                print("FirebaseService - registerUser Success")
                let db = Firestore.firestore()
                // 계정 생성 성공하면 url값 유무에 따라 Firestore에 계정 데이터 저장
                if url == "" {
                    downloadImageUrl(imageName: "profileImage_\(email)") { url in
                        db.collection("users").document(result!.user.uid)
                            .setData(["id":result?.user.uid,
                                      "email": email,
                                      "password": password,
                                      "username": userName,
                                      "url":url.absoluteString])
                    }
                } else {
                    db.collection("users").document(result!.user.uid)
                        .setData(["id":result?.user.uid,
                                  "email": email,
                                  "password": password,
                                  "username": userName,
                                  "url":url])
                }
                
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
    static func createChatRoom(destinationUserUid: String, completion: @escaping() -> Void) {
        print("FirebaseService - createChatRoom() called")
        if let uid = getCurrentUser()?.uid {
            //TODO: - ChatData Struct내부에서 UUID정의
            let chatUID = "CHAT-\(UUID())"
            getUserWithUid(destinationUid: destinationUserUid, completion: { loadInfo in
                
                //User에 가지고있는 채팅방이 뭔지 저장
                db.collection("users")
                    .document("\(uid)")
                    .collection("groups")
                    .document(chatUID)
                    .setData(["chatUid":"\(chatUID)",
                              "destinationUid":"\(destinationUserUid)",
                              "destinationUserName":"\(loadInfo.username)",
                              "destinationUrl":"\(loadInfo.url)",
                              "senderUid":"\(uid)"])
                
                //전체 Chat목록에 저장
                db.collection("chats")
                    .document(chatUID)
                    .setData(["chatUid":"\(chatUID)",
                              "destinationUid":"\(destinationUserUid)",
                              "destinationUserName":"\(loadInfo.username)",
                              "destinationUrl":"\(loadInfo.url)",
                              "senderUid":"\(uid)"])
                completion()
            })
            getUserWithUid(destinationUid: uid, completion: { username in
                // 상대 User에도 채팅방 저장
                db.collection("users")
                    .document("\(destinationUserUid)")
                    .collection("groups")
                    .document(chatUID)
                    .setData(["chatUid":"\(chatUID)",
                              "destinationUid":"\(uid)",
                              "destinationUserName":"\(username.username)",
                              "destinationUrl":"\(username.url)",
                              "senderUid":"\(destinationUserUid)"])
            })
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
    static func getUserWithUid(destinationUid: String, completion: @escaping (firesotreUsers) -> Void){
        
        db.collection("users").document("\(destinationUid)").getDocument {
            documentSnapshot, error in
            
            if let error = error {
                print("Error: \(error)")
            } else {
                
                guard let documents = documentSnapshot?.data() else { return }
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try JSONSerialization.data(withJSONObject: documents)
                    let roadInfo = try decoder.decode(firesotreUsers.self, from: jsonData)
                    completion(roadInfo)
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    //MARK: - 채팅방 가져오기
    static func getChatContent(chatUid: String, completion: @escaping(ChatRoom) -> Void) {
        db.collection("chats").document("\(chatUid)").getDocument{
            documentSnapshot, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                guard let documents = documentSnapshot?.data() else { return }
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try JSONSerialization.data(withJSONObject: documents)
                    let roadInfo = try decoder.decode(ChatRoom.self, from: jsonData)
                    completion(roadInfo)
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    //MARK: - 채팅방의 메세지내용 가져오기
    static func getMessage(chatUid: String, completion: @escaping([ChatMessage]) -> Void) {
        db.collection("chats")
            .document("\(chatUid)")
            .collection("messages")
            .order(by: "timestamp")
            .getDocuments() { (querySnapshot, error) in
            var roadInfos: [ChatMessage] = []
            
            if let error = error {
                print("error: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else { return }
                let decoder = JSONDecoder()
                
                for document in documents {
                    do {
                        let data = document.data()
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let roadInfo = try decoder.decode(ChatMessage.self, from: jsonData)
                        roadInfos.append(roadInfo)
                    } catch let error {
                        print("err \(error)")
                    }
                }
                completion(roadInfos)
            }
        }
    }
    
    //MARK: - 채팅방에 메세시 보내기 (FireStore에 저장)
    static func sendMessage(chatUid: String, text: String) {
        print("FirebaseService - sendMessage() called")
        if let uid = getCurrentUser()?.uid {
            let messageUID = "\(UUID())"
            db.collection("chats")
                .document("\(chatUid)")
                .collection("messages")
                .document(messageUID)
                .setData(["content": "\(text)",
                          "id": "\(messageUID)",
                          "senderUid":"\(uid)",
                          "timestamp":"\(Date())"])
        }
    }
    
    //MARK: - 채팅방에 메세지의 값이 변경되면 감지
    static func observedData(chatUid: String, completion: @escaping() -> Void) {
        db.collection("chats")
            .document("\(chatUid)")
            .collection("messages")
            .addSnapshotListener(includeMetadataChanges: true, listener: { querySnapshot, error in
                guard let document = querySnapshot else {
                    print("Error fetching document : \(error!)")
                    return
                }
                completion()
            })
    }
    
    //MARK: - 이미지 Storage에 업로드
    static func uploadImage(image: Data?, imageName: String) {
        let storageRef = Storage.storage().reference().child("images/\(imageName)")
        let data = image
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let data = data{
            storageRef.putData(data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error: \(error)")
                }
                if let metadata = metadata {
                    print("metadata: \(metadata)")
                }
            }
        }
    }
    
    //MARK: - Storage에 있는 프로필 이미지의 URL을 가져옴
    static func downloadImageUrl(imageName: String, completion: @escaping(URL) -> Void) {
        let storageRef = Storage.storage().reference().child("images/\(imageName)")
        storageRef.downloadURL { (url, error) in
            if let error = error {
                print("Error: \(error)")
            }
            if let url = url {
                print("URL: \(url)")
                completion(url)
            }
        }
    }
}
