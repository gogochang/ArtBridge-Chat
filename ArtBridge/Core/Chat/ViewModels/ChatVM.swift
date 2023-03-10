//
//  ChatVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/03.
//

import Foundation

class ChatVM: ObservableObject {
    
    @Published var chatMessages: [ChatMessage] = []
    
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
    
    //메세지 가져오기
    func getMessages(chatUid: String) {
        // FireStore 값 변경 감지
        FirebaseService.observedData(chatUid: chatUid) {
            // FireStore에 채팅내용 데이터를 변수에 저장
            FirebaseService.getMessage(chatUid: chatUid) { loadInfos in
                self.chatMessages = loadInfos
            }
        }
    }
}
