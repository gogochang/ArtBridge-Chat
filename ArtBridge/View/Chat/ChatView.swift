//
//  ChatView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/16.
//

import SwiftUI

struct ChatView: View {

    @Binding var chatUid: String
    @State var chatMessages: [ChatMessage] = []
    @State var message: String = ""
    
    var body: some View {
        VStack() {
//            List(chatMessages) { aMessage in
//                if FirebaseService.getCurrentUser()?.uid == aMessage.senderUid {
//                    HStack() {
//                        Spacer()
//                        Text("\(aMessage.content)")
            
//                    }
//                } else {
//                    HStack() {
//                        Text("\(aMessage.content)")
//                        Spacer()
//                    }
//                }
//            }//List
            ScrollView {
                LazyVStack {
                    ForEach(chatMessages) { aMessage in
                        if FirebaseService.getCurrentUser()?.uid == aMessage.senderUid {
                            HStack() {
                                Spacer()
                                Text("\(aMessage.content)")
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                        } else {
                            HStack() {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text("\(aMessage.content)")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .onAppear(perform: {
                FirebaseService.getMessage(chatUid: chatUid) { roadInfos in
                    chatMessages = roadInfos
                }
                FirebaseService.observedData(chatUid: chatUid) {
                    FirebaseService.getMessage(chatUid: chatUid) { roadInfos in
                        chatMessages = roadInfos
                        message = ""
                    }
                }
            })//onAppear
            HStack() {
                TextField("메세지를 입력해주세요.",text: $message)
                Button(action: {
                    print("Send Button is Clicked")
                    FirebaseService.sendMessage(chatUid: chatUid,text: message)
                }, label: {
                    Text("Send")
                })
            }//HStack
        }
        

    }//body
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
