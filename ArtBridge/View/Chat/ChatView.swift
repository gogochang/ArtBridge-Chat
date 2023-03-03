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
    
    @EnvironmentObject var userVM : UserVM
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
                    // 현재 유저 uid 정보 가져오기
                    userUid = FirebaseService.getCurrentUser()?.uid
                    
                    // 현재 유저의 프로필 이미지 데이터 가져오기
                    chatVM.getDataFromUrl(uid: chatRoom.senderUid) { data in
                        self.profileImg = UIImage(data: data) ?? UIImage(systemName: "person.circle")
                    }
                    
                    // 상대 유저의 프로필 이미지 데이터 가져오기
                    chatVM.getDataFromUrl(uid: chatRoom.destinationUid) { data in
                        self.destinationProfileImg = UIImage(data: data) ?? UIImage(systemName: "person.circle")
                    }
                    
                    //메세지내용 가져오기
                    FirebaseService.getMessage(chatUid: chatRoom.id) { loadInfos in
                        chatMessages = loadInfos
                        proxy.scrollTo(bottomID)
                    }
                    //메세지 firestore의 내부 값이 변경되면 감지하기
                    FirebaseService.observedData(chatUid: chatRoom.id) {
                        FirebaseService.getMessage(chatUid: chatRoom.id) { loadInfos in
                            chatMessages = loadInfos
                            message = ""
                        }
                    }
                })//onAppear
                .onReceive(userVM.$destinationData) { data in
                    print("ChatView - onReceive()  $destinationData called")
                    self.destinationProfileImg = UIImage(data: data) ?? UIImage(systemName: "person.circle")
                }
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
