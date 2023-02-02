//
//  PostRouter.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/01.
//

import Foundation
import Alamofire

enum PostRouter: URLRequestConvertible {
    
    case loadPostData
    case createPostData
    
    var baseURL: URL {
        return URL(string: ApiClient.URL)!
    }
    
    var endPoint: String {
        switch self {
        case .loadPostData:
            return "art-bridge-posts"
        case .createPostData:
            return ""
        default:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loadPostData:
            return .get
        case .createPostData:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        default: return Parameters()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        request.method = method
        return request
    }
}
