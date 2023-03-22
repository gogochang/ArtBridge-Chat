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
        let query = Firestore.firestore().collection("users")
            .document(uid)
            .collection("chats")
            .document(chatRoom.toUser.uid)
            .collection("messages")
            .order(by: "timestamp", descending: false)
        
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
        let data = ["text": messageText,
                    "user": fromUser,
                    "timestamp": Timestamp(date: Date())] as [String : Any]
        
        //메세지 저장
        let currentUserRef = Firestore.firestore().collection("users").document(currentUser.uid).collection("chats").document(chatPartner.uid).collection("messages").document()
        let chatPartnerRef = Firestore.firestore().collection("users").document(chatPartner.uid).collection("chats").document(currentUser.uid).collection("messages")
        
        let messagesID = currentUserRef.documentID
        
        //최신 메세지 저장
        let recentCurrentUserRef = Firestore.firestore().collection("users").document(currentUser.uid).collection("chats").document(chatPartner.uid)
        let recentChatPartnerRef = Firestore.firestore().collection("users").document(chatPartner.uid).collection("chats").document(currentUser.uid)
        
        
        currentUserRef.setData(data)
        chatPartnerRef.document(messagesID).setData(data)
        
        recentCurrentUserRef.updateData(["recentMessage": data])
        recentChatPartnerRef.updateData(["recentMessage": data])
    }
}
