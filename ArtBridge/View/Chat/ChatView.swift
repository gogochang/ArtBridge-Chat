//
//  ChatView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/16.
//

import SwiftUI

struct ChatView: View {

    @Binding var chatRoom: ChatRoom
    @State var userUid: String?
    @State var chatMessages: [ChatMessage] = []
    @State var message: String = ""
    @State private var profileImg: UIImage? = UIImage(systemName: "person.circle")
    @State private var destinationProfileImg: UIImage? = UIImage(systemName: "person.circle")
    
    var chatVM = ChatVM()
    
    @Namespace var bottomID
    
    var body: some View {
        VStack() {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(chatMessages) { aMessage in
                            if FirebaseService.getCurrentUser()?.uid == aMessage.senderUid {
                                HStack() {
                                    Spacer()
                                    Text("\(aMessage.content)")
                                    Image(uiImage: profileImg!)
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .clipShape(Circle())
                                }
                            } else {
                                HStack() {
                                    Image(uiImage: destinationProfileImg!)
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .clipShape(Circle())
                                    Text("\(aMessage.content)")
                                    Spacer()
                                }
                            }
                        }
                    }
                    Text("").id(bottomID)
                }//ScrollView
                // 메인 스레드에서 작동하기 때문에 짧은 동작만
                .onChange(of:chatMessages.count) { _ in
                    proxy.scrollTo(bottomID)
                }
                .onAppear(perform: {
                    // 현재 유저의 프로필 이미지 데이터 가져오기
                    chatVM.getDataFromUrl(uid: chatRoom.senderUid) { data in
                        self.profileImg = UIImage(data: data) ?? UIImage(systemName: "person.circle")
                    }
                    
                    // 상대 유저의 프로필 이미지 데이터 가져오기
                    chatVM.getDataFromUrl(uid: chatRoom.destinationUid) { data in
                        self.destinationProfileImg = UIImage(data: data) ?? UIImage(systemName: "person.circle")
                    }
                    // 메세지 내용 가져오기
                    chatVM.getMessages(chatUid: chatRoom.id)
                    
                })//onAppear
                
                // 메세지 내용이 변경되면 ChatView의 chatMessages의 변수에 갱신
                .onReceive(chatVM.$chatMessages, perform: { self.chatMessages = $0 })
                HStack() {
                    TextField("메세지를 입력해주세요.",text: $message)
                    Button(action: {
                        print("Send Button is Clicked")
                        FirebaseService.sendMessage(chatUid: chatRoom.id,text: message)
                    }, label: {
                        Text("Send")
                    })
                }//HStack
            }//ScrollViewReader
        }
    }//body
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
