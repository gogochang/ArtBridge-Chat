//
//  LoginVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/14.
//

import Foundation
import Combine
import Firebase

class UserVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var currentUser: Firebase.User?
    
    //Input
    @Published var emailInput: String = ""
    @Published var passwordInput: String = ""
    
    @Published var loggedInUser: UserResponse? = nil
    
    // 로그인 완료 이벤트
    var logInSuccess = PassthroughSubject<(), Never>()
    
    // 로그인 하기
    func logIn() {
        print("UserVM - logIn() called email: \(emailInput), password: \(passwordInput)")
        FirebaseService.logIn(email: emailInput, password: passwordInput) {
            self.getCurrentUser()
            self.logInSuccess.send()
        }
    }
    
    func logOut() {
        print("UserVM - logOut() called")
        FirebaseService.logOut() {
            self.currentUser = nil
        }
    }
    // 현재 유저 가져오기
    func getCurrentUser() {
        print("UserVM - currentUser() called")
        currentUser = FirebaseService.getCurrentUser()
    }
}
