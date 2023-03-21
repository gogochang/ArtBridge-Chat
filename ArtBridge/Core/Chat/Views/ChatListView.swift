//
//  ChatListView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/21.
//

import SwiftUI
import Kingfisher

struct ChatListView: View {
    @ObservedObject var viewModel = ChatListVM()
    
    var body: some View {
        VStack {
            List(viewModel.chatRooms) { chatRoom in
                    HStack {
                        KFImage(URL(string:chatRoom.toUser.profileUrl))
                            .resizable()
                            .clipShape(Circle())
                            .frame(maxWidth: 50, maxHeight: 50)
                        
                        VStack(alignment: .leading) {
                            Text(chatRoom.toUser.username)

                        }
                        NavigationLink(destination: ChatView(chatRoom: chatRoom), label: {
                        })// Navigation
                        .opacity(0)
                    }
            }
            .listStyle(PlainListStyle())
        }.onAppear(perform: {
            viewModel.fetchChats()
        })
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
