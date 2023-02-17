//
//  ChatView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/16.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var userVM : UserVM
    
    var body: some View {
        VStack() {
            
            //현재 유저
            Button(action: {
                print("firebase currentUser -> \(userVM.currentUser?.email)")
            }, label: {
                Text("CurrentUsers")
            })
            
            // 로그아웃
            Button(action: {
                print("LogOut Button is Clicked")
                userVM.logOut()
            }, label: {
                Text("LogOut")
            })
            
            // 채팅방 목록으로 이동
            Button(action: {
                print("GoChatRooms Button is Clicked")
                userVM.getCurrentUser()
            }, label: {
                Text("Go Chat Rooms")
            })
            
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
