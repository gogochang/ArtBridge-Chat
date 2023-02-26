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
    @Published var loggedUser: firesotreUsers?
    @Published var data = Data()
    
    //Input
    @Published var emailInput: String = ""
    @Published var passwordInput: String = ""
    
    @Published var loggedInUser: UserResponse? = nil
    
    // 로그인 완료 이벤트
    var logInSuccess = PassthroughSubject<(), Never>()
    
    // 로그인 하기
    func logIn() {
        print("UserVM - logIn() called")
        FirebaseService.logIn(email: emailInput, password: passwordInput) {
            self.getCurrentUser()
        }
    }
    // 로그아웃
    func logOut() {
        print("UserVM - logOut() called")
        FirebaseService.logOut() {
            self.currentUser = nil
            self.loggedUser = nil
            self.emailInput = ""
            self.passwordInput = ""
            self.data = Data()
        }
    }
    // 현재 유저 가져오기
    func getCurrentUser() {
        print("UserVM - currentUser() called")
        currentUser = FirebaseService.getCurrentUser()
        if let user = currentUser {
            FirebaseService.getUserWithUid(destinationUid: user.uid) { loadInfo in
                // firestoreUsers 타입의 데이터를 가져와서 변수에 저장!
                self.loggedUser = loadInfo
                // 가져온 URL로 이미지 데이터를 가져오는 함수 실행!!
                self.getDataFromUrl(urlString: loadInfo.url)
            }
        } else {
            print("UserVM - guetUserFromFirestore() curreuntUser is nil")
        }
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
