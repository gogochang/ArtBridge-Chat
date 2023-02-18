//
//  FirebaseService.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/17.
//

import Foundation
import Firebase

enum FirebaseService {
    
    // 로그인
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
    
    // 로그아웃
    static func logOut(completion: @escaping() -> Void) {
        print("FirebaseService - logOut() called")
        if let data = try? Auth.auth().signOut() {
            print("FirebaseService - logOut() called \(data)")
            completion()
        }
    }
    
    // 회원가입
    static func registerUser(userName: String, email: String, password: String, completion: @escaping () -> Void) {
        print("FirebaseService - registerUser() called")
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                let db = Firestore.firestore()
                db.collection("users").document(email).setData(["id":result?.user.uid,"email": email, "password": password,"username": userName])
                completion()
            }
        }
    }
    
    //현재 유저
    static func getCurrentUser() -> Firebase.User? {
        print("FirebaseService - getCurrentUser() called")
        let user = Auth.auth().currentUser
        return user
    }
    
    //모든 유저목록 가져오기
    static func getAllUsers(completion: @escaping ([firesotreUsers]) -> Void) {
        let db = Firestore.firestore()
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
}
