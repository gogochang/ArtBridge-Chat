//
//  ChatListView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/21.
//

import SwiftUI
import Kingfisher

struct ChatListView: View {
    @ObservedObject var viewModel = ChatVM()
    
    var body: some View {
        VStack {
            List(viewModel.toUsers) { user in
                    HStack {
                        KFImage(URL(string:user.toUser.profileUrl))
                            .resizable()
                            .clipShape(Circle())
                            .frame(maxWidth: 50, maxHeight: 50)
                        
                        VStack(alignment: .leading) {
                            Text(user.toUser.username)
                            Text(user.toUser.email)
                        }
                        NavigationLink(destination: ChatView(), label: {
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
