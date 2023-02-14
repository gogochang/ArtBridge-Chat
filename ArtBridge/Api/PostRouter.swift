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
    case createPostData(title: String, contents: String, author: String)
    case removePostData(id: Int)
    case editPostData(title: String, contents: String, author: String, id: Int)
    
    var baseURL: URL {
        return URL(string: ApiClient.URL)!
    }
    
    var endPoint: String {
        switch self {
        case .loadPostData:
            return "art-bridge-posts"
        case .createPostData:
            return "art-bridge-posts"
        case .removePostData(let id):
            return "art-bridge-posts/\(id)"
        case .editPostData(_, _, _, let id):
            return "art-bridge-posts/\(id)"
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
        case .removePostData:
            return .delete
        case .editPostData:
            return .put
        default:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .createPostData(let title, let contents, let author):
            return ["data": [ "title": title,
                              "contents": contents,
                              "author": author]]
        case .editPostData(let title, let contents, let author, _):
            return ["data": ["title": title,
                             "contents": contents,
                             "author": author]]
        default: return Parameters()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        request.method = method

        switch self {
        case .createPostData:
            request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        case .editPostData:
            request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        default:
            break
        }
        
        return request
    }
}
