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
        VStack(alignment:.leading) {
            HStack() {
                Text("채팅")
                    .fontWeight(.heavy)
                    .font(.title3)
                    
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 8, trailing: 10))
            
            Divider()
            List(viewModel.chatRooms) { chatRoom in
                HStack(alignment: .bottom) {
                    KFImage(URL(string:chatRoom.toUser.profileUrl))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(maxWidth: 50, maxHeight: 50)
                    
                    VStack(alignment: .leading) {
                        Text(chatRoom.toUser.username)
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.bottom, 2)
                        Text(chatRoom.recentMessage?.text ?? " ")
                            .foregroundColor(Color(.systemGray))
                            .font(.system(size: 14))
                    }
                    NavigationLink(destination: ChatView(chatRoom: chatRoom), label: {
                    })// Navigation
                    .opacity(0)
                    if let timeStamp = chatRoom.recentMessage?.timestamp {
                        Text(DateManager.timeStampToString(timeStamp) )
                            .foregroundColor(Color(.systemGray2))
                            .font(.system(size: 14))
                    }
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
