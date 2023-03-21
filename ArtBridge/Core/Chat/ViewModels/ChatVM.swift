//
//  ChatVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/21.
//

import Foundation
import Firebase

class ChatVM: ObservableObject {
    @Published var messages = [Message]()
    
    private let chatRoom: ChatRoom
    
    init(chatRoom: ChatRoom) {
        self.chatRoom = chatRoom
        fetchMessages()
    }

    //MARK: 메세지 가져오기
    func fetchMessages() {
        print("ChatVM - fetchMessages() called")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query = Firestore.firestore().collection("users").document(uid).collection("chats").document(chatRoom.id!).collection("messages")
        
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
            
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            let addedMessages = changes.compactMap{ try? $0.document.data(as: Message.self) }
            self.messages.append(contentsOf: addedMessages)
        }
        
            query.getDocuments { snapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                
                let messages = documents.compactMap({ try? $0.data(as: Message.self)})
                self.messages = messages
            }
    }
    //MARK: 메세지 보내기
    func sendMessage(messageText: String) {
        print("ChatVM - sendMessage() called")
        let currentUser = chatRoom.fromUser
        let chatPartner = chatRoom.toUser
        
        let fromUser = ["username":currentUser.username,
                        "profileUrl":currentUser.profileUrl,
                          "uid":currentUser.uid,
                          "email":currentUser.email]
        
        let toUser = ["username":chatPartner.username,
                      "profileUrl":chatPartner.profileUrl,
                      "uid":chatPartner.uid,
                      "email":chatPartner.email]
        
        let data = ["text": messageText,
                    "user": fromUser,
                    "timestamp": Timestamp(date: Date())] as [String : Any]
        
        let currentUserRef = Firestore.firestore().collection("users").document(currentUser.uid).collection("chats").document(chatRoom.id!).collection("messages").document()
        let chatPartnerRef = Firestore.firestore().collection("users").document(chatPartner.uid).collection("chats").document(chatRoom.id!).collection("messages")
        
        let messagesID = currentUserRef.documentID
        
        currentUserRef.setData(data)
        chatPartnerRef.document(messagesID).setData(data)
    }
}
