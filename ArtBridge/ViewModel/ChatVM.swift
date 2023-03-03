//
//  ChatVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/03.
//

import Foundation

class ChatVM: ObservableObject {
    
    // 내 프로필 이미지 UID -> profile Image Data
    func getDataFromUrl(uid: String, completion: @escaping(Data) -> Void){
        print("ChatVM - getDataFromUrl() called")
        FirebaseService.getUserWithUid(destinationUid: uid) { loadInfo in
            guard let url = URL(string: loadInfo.url) else { return }
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, self != nil else { return }
                DispatchQueue.main.sync {
                    completion(data)
                }
            }
            task.resume()
        }
    }
}
