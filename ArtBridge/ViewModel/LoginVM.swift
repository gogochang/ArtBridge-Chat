//
//  LoginVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/14.
//

import Foundation
import Alamofire
import Combine

class LoginVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    func login(userName: String, password: String) {
        print("LoginVM - login() called")
        AccountApiServie.login(userName: userName, password: password)
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("LoginVM - registerUser() Completion : \(completion)")
            } receiveValue: { (receivedData: LoginData) in
                print("chang - \(receivedData)")
            }.store(in: &subscription)
    }
}


