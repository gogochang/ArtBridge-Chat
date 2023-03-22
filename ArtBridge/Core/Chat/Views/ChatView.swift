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
    
    //스크롤뷰 이동
    @Namespace var topID
    @Namespace var bottomID
    
    init(chatRoom: ChatRoom) {
        self.chatRoom = chatRoom
        self.viewModel = ChatVM(chatRoom: chatRoom)
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    Button(
                        action: { withAnimation { proxy.scrollTo(bottomID) } },
                        label: { Image(systemName: "chevron.down").foregroundColor(Color(.systemGray2)) })
                        .id(topID)
                    
                    VStack(alignment: .leading) {
                        ForEach(viewModel.messages) { message in
                            HStack(alignment: .top) {
                                //MARK: 현재 유저의 메세지
                                if (message.user.uid == Auth.auth().currentUser?.uid) {
                                    Spacer()
                                    //현재 유저 채팅 텍스트
                                    HStack(alignment:.bottom) {
                                        Text("\(DateManager.timeStampToString(message.timestamp) )")
                                            .foregroundColor(Color(.systemGray2))
                                            .font(.system(size: 14))
                                        
                                        Text(message.text)
                                            .padding(12)
                                            .background(message.user.uid == Auth.auth().currentUser?.uid ? Color(.systemBlue).opacity(0.3) : Color(.systemGroupedBackground))
                                            .clipShape(Capsule())
                                            .foregroundColor(Color.black)
                                    }
                                //MARK: 상대 유저 메세지
                                } else {
                                    // 상대 프로필 이미지
                                    KFImage(URL(string: message.user.profileUrl))
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(maxWidth: 36, maxHeight: 36)
                                    VStack(alignment: .leading) {
                                        // 상대 유저 이름
                                        Text(message.user.username)
                                            .foregroundColor(Color(.systemGray2))
                                            .font(.system(size: 14))
                                            .padding(.bottom, 2)
                                        HStack(alignment:.bottom) {
                                            // 상대 채팅 텍스트
                                            Text(message.text)
                                                .padding(12)
                                                .background(message.user.uid == Auth.auth().currentUser?.uid ? Color(.systemBlue).opacity(0.2) : Color(.systemGroupedBackground))
                                                .clipShape(Capsule())
                                                .foregroundColor(Color.black)
                                                .padding(.leading, message.user.uid == Auth.auth().currentUser?.uid ? 40 : 0 )
                                            Text("\(DateManager.timeStampToString(message.timestamp) )")
                                                .foregroundColor(Color(.systemGray2))
                                                .font(.system(size: 14))
                                        }
                                    } //Vstack
                                } // if - else
                            } //HStack
                        } //ForEach
                        Text("").id(bottomID)
                    } //VStack
                    .padding()
                    //메세지 개수가 바뀌면 제일 아래화면으로 스크롤 이동하기
                    .onChange(of: viewModel.messages.count) { _ in withAnimation { proxy.scrollTo(bottomID) } }
                    .onAppear { withAnimation { proxy.scrollTo(bottomID) } }
                } //ScrollView
            } //ScrollViewReader
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
                }).disabled(text == "")
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
