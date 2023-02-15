//
//  AccountApiServie.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/10.
//

import Foundation
import Alamofire
import Combine

enum UserApiServie {
    
    static func registerUser(userName: String, password: String, email: String) -> AnyPublisher<LoginResponse, AFError> {
        print("AccountApiService - registerUser() called , name: \(userName), password: \(password), email: \(email)")
        
        return ApiClient.shared.session
            .request(AccountRouter.registerData(userName: userName, password: password, email: email))
            .publishDecodable(type:LoginResponse.self)
            .value()
            .map{ receivedValue in
                return receivedValue
            }.eraseToAnyPublisher()

    }
    
    static func login(userName: String, password: String) -> AnyPublisher<UserResponse, AFError>{
        print("AccountApiService - login() called, name : \(userName), password: \(password)")
        
        return ApiClient.shared.session
            .request(AccountRouter.loginData(userName: userName, password: password))
            .responseData{ dataResponse in
                print("chang22 -> \(dataResponse)")
            }
            .publishDecodable(type: UserResponse.self)
            .value()
            .map{ receivedValue in
                print("chang -> \(receivedValue)")
                return receivedValue
            }.eraseToAnyPublisher()
    }
}
