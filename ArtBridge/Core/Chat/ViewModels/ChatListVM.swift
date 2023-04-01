//
//  ChatVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/21.
//

import Foundation
import Firebase

class ChatListVM: ObservableObject {
    
    @Published var chatRooms = [ChatRoom]()
    
    //MARK: - 현재 유저의 채팅목록 가져오기
    func fetchChats() {
        print("ChatVM - fetchChats() called")
        guard let uid = Auth.auth().currentUser?.uid else {
            chatRooms = [ChatRoom]()
            return
        }
        
        let query = Firestore.firestore().collection("users").document(uid).collection("chats")
        
        //채팅방 가져오기
        query.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            let chats = documents.compactMap({ try? $0.data(as: ChatRoom.self)})
            self.chatRooms = chats
        }
        
        //채팅방 변화감지
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
            
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .modified }) else { return }
            let addChatRooms = changes.compactMap{ try? $0.document.data(as: ChatRoom.self) }
            if !addChatRooms.isEmpty {
                self.chatRooms = addChatRooms
            }
        }
    }
}
