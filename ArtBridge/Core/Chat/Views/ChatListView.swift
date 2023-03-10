//
//  ChatListView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/18.
//

import SwiftUI

struct ChatListView: View {
    
    @State var chatRooms: [ChatRoom] = []
    @State var chatRoom: ChatRoom = ChatRoom()
    @State var tag:Int? = nil
    
    var body: some View {
        NavigationView {
            
             VStack() {
                 NavigationLink(destination: ChatView(chatRoom: $chatRoom), tag: 1, selection: self.$tag ) {
                     EmptyView()
                 }
                 
                List(chatRooms) { aRoom in
                    
                    Button {
                        print("Chat List Item  is Clicked, chatuid : \(aRoom.id)")
                        //TODO: - 채팅화면으로 이동
                        self.tag = 1
                        self.chatRoom = aRoom
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
                        self.chatRooms = roadInfos
                    }
                })
            }//VStack
        }
    }
}

//struct ChatListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatListView()
//    }
//}
