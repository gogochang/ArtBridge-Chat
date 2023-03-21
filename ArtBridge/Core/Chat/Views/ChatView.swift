//
//  ChatView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/21.
//

import SwiftUI
import FirebaseAuth
import Kingfisher

struct ChatView: View {
    private let chatRoom: ChatRoom
    @ObservedObject var viewModel: ChatVM
    
    @State var text: String = ""
    
    init(chatRoom: ChatRoom) {
        self.chatRoom = chatRoom
        self.viewModel = ChatVM(chatRoom: chatRoom)
    }
    
    var body: some View {

        VStack {
            List(viewModel.messages) { message in
                if (message.user.uid == Auth.auth().currentUser?.uid) {
                    HStack {
                        
                        Spacer()
                        Text(message.text)
                        KFImage(URL(string: message.user.profileUrl))
                            .resizable()
                            .clipShape(Circle())
                            .frame(maxWidth: 25, maxHeight: 25)
                            
                    }
                } else {
                    HStack {
                        KFImage(URL(string: message.user.profileUrl))
                            .resizable()
                            .clipShape(Circle())
                            .frame(maxWidth: 25, maxHeight: 25)
                        Text(message.text)
                        Spacer()
                    }
                }
            }
            // 댓글 입력창 TextField 설정
            ZStack(alignment: .trailing) {
                TextField("메세지를 입력하세요", text: $text)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                    .cornerRadius(16)
                
                // Button에 이미지 추가
                Button(action: {
                    print("SendButton is Clicked")
                    viewModel.sendMessage(messageText: text)
                    self.text = ""
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.trailing, 16)
                        .frame(width: 40, height: 40)
                })
            }.padding(.horizontal,10)
        }
        .navigationTitle(chatRoom.toUser.username)
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
