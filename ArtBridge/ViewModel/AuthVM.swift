//
//  AuthVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/16.
//

import Foundation
import Firebase

class AuthVM: ObservableObject {
    
    @Published var currentUser: Firebase.User?
    
    // 로그인
    func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            
            self.currentUser = result?.user
        }
    }
    
    // 로그아웃
    func logOut() {
        currentUser = nil
        try? Auth.auth().signOut()
    }
    
    // 회원가입
    func registerUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            
            print(user.uid)
        }
    }
}
