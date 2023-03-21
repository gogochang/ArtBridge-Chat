//
//  ChatVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/21.
//

import Foundation
import Firebase

class ChatVM: ObservableObject {
    
    @Published var toUsers = [ChatRoom]()
    
    //현재 유저의 채팅목록 가져오기
    func fetchChats() {
        print("ChatVM - fetchChats() called")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).collection("chats")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                let chats = documents.compactMap({ try? $0.data(as: ChatRoom.self)})
                self.toUsers = chats
            
            }
    }
}
