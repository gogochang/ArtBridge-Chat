//
//  LoginVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/14.
//

import Foundation
import Combine
import Firebase
import FirebaseCore
import FirebaseAuth
import KakaoSDKUser
//import GoogleSignIn

class UserVM: ObservableObject {
    let service = UserService()
    
    var subscription = Set<AnyCancellable>()
    
    @Published var userSession: Firebase.User?
    @Published var currentUser: User?
    @Published var data = Data()
    
    //Input
    @Published var emailInput: String = ""
    @Published var passwordInput: String = ""
    
    // 로그인 완료 이벤트
    var logInSuccess = PassthroughSubject<(), Never>()
    
    @Published var didLoginUser = false
    @Published var didUpdateUser = false
    
    // 로그인 하기
    func logIn() {
        print("UserVM - logIn() called")
        service.logIn(email: emailInput, password: passwordInput) { user in
            self.userSession = user
            self.fetchUser()
            self.didLoginUser = true
        }
    }

    // 유저 정보를 currentUser(User Struct)에 저장
    func fetchUser() {
        print("UserVM - fetchUser() called")
        guard let uid = self.userSession?.uid else { return }
        service.fetchUser(uid: uid) { user in
            self.currentUser = user
        }
    }
    
    // 유저 정보 변경
    func updateUser(displayName: String?, profileUrl: String?) {
        print("UserVM - updateUser() called")
        guard let user = self.userSession else { return }
        service.editUser(username: displayName ?? user.displayName!,
                         profileUrl: profileUrl ?? (user.photoURL?.absoluteString)!)
        fetchUser()
        didUpdateUser = true
    }
    
    // 로그아웃
    func logOut() {
        print("UserVM - logOut() called")
        // 로그인 확인 false
        didLoginUser = false
        // user
        userSession = nil
        currentUser = nil
        try? Auth.auth().signOut()
    }
    
    func getDataFromUrl(urlString: String) {
        print("UserVM - getDataFromUrl() called")
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, self != nil else { return }
            DispatchQueue.main.sync { [ weak self] in
                self?.data = data
                self?.logInSuccess.send()
            }
        }
        task.resume()
    }
}
