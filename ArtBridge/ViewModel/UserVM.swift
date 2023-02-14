//
//  LoginVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/14.
//

import Foundation
import Alamofire
import Combine

class UserVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var loggedInUser: UserResponse? = nil
    
    // 로그인 완료 이벤트
    var registrationSuccess = PassthroughSubject<(), Never>()
    
    func login(userName: String, password: String) {
        print("LoginVM - login() called")
        UserApiServie.login(userName: userName, password: password)
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("LoginVM Completion : \(completion)")
            } receiveValue: { (receivedUser: UserResponse) in
                print("LoginVM receiveValue")
                self.loggedInUser = receivedUser
                self.registrationSuccess.send()
            }.store(in: &subscription)
    }
}


