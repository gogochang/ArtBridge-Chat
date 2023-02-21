//
//  ChatListView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/18.
//

import SwiftUI

struct ChatListView: View {
    
    @State var chatRooms: [ChatRoom] = []
    
    var body: some View {
        VStack() {
            List(chatRooms) { aRoom in
                Button {
                    print("Chat List Item  is Clicked")
                    //TODO: - 채팅화면으로 이동 
                } label: {
                    HStack() {
                        Text(aRoom.destinationUserName)
                        Spacer()
                        Image(systemName: "arrowshape.right")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }//HStack
                }
            }
            .listStyle(PlainListStyle())
            .onAppear(perform: {
                print("ChatListView - onAppear() called")
                FirebaseService.fetchChatRoomList() { roadInfos in
                    print(roadInfos)
                    self.chatRooms = roadInfos
                }
            })
            Button {
                print("getUserNameWithUID Button is Clicked")
            } label: {
                Text("UID로 유저아이디 가져오기")
            }
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
