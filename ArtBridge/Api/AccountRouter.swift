//
//  AccountRouter.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/14.
//

import Foundation
import Alamofire

enum AccountRouter: URLRequestConvertible {
    
    case registerData(userName: String, password: String, email: String)
    case loginData(userName: String, password: String)
    
    var baseURL: URL {
        return URL(string: ApiClient.URL)!
    }
    
    //MARK: - EndPoint
    var endPoint: String {
        switch self {
        case .registerData:
            return "auth/local/register"
        case .loginData:
            return "auth/local"
        default:
            return ""
        }
    }
    
    //MARK: - Method
    var method: HTTPMethod {
        switch self {
        case .registerData:
            return .post
        case .loginData:
            return .post
        default:
            return .get
        }
    }
    
    //MARK: - Parameters
    var parameters: Parameters {
        switch self {
        case .registerData(let userName, let password, let email):
            return [ "username" : userName,
                     "email" : email,
                     "password" : password]
        case .loginData(let userName , let password):
            return [ "identifier" : userName,
                     "password" : password]
        default :
            return Parameters()
        }
    }
    
    //MARK: - URL Request
    func asURLRequest() throws -> URLRequest {
        print("AccountRouter - asURLRequest() called ")
        let url = baseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case .registerData:
            request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        case .loginData:
            request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        default:
            break
        }
        return request
    }
    
}
