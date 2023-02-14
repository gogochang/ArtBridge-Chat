//
//  AccountApiServie.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/10.
//

import Foundation
import Alamofire
import Combine

enum AccountApiServie {
    static func registerUser(userName: String, password: String, email: String) -> AnyPublisher<AccountData, AFError> {
        print("AccountApiService - registerUser() called , name: \(userName), password: \(password), email: \(email)")
        
        return ApiClient.shared.session
            .request(AccountRouter.registerData(userName: userName, password: password, email: email))
            .publishDecodable(type:AccountData.self)
            .value()
            .map{ receivedValue in
                return receivedValue
            }.eraseToAnyPublisher()

    }
}
