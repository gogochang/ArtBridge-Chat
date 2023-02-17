//
//  ChatView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/16.
//

import SwiftUI

struct ChatView: View {
    
    @State var testEmail: String = ""
    @State var testPassword: String = ""
    @ObservedObject var authVM = AuthVM()
    
    var body: some View {
        VStack() {
            TextField("test",text:$testEmail)
            TextField("test",text:$testPassword)
            
            Button(action: {
                print("firebase currentUser -> \(authVM.currentUser?.uid)")
            }, label: {
                Text("CurrentUsers")
            })
            
            //회원가입
            Button(action: {
                print("Register Button is Clicked")
                authVM.registerUser(email: testEmail, password: testPassword)
            }, label: {
                Text("Register")
            })
            
            //로그인
            Button(action: {
                print("Login Button is Clicked")
                authVM.logIn(email: testEmail, password: testPassword)
            }, label: {
                Text("Login")
            })
            
            Button(action: {
                print("LogOut Button is Clicked")
                authVM.logOut()
            }, label: {
                Text("LogOut")
            })
            
            // 채팅방 목록으로 이동
            Button(action: {
                print("GoChatRooms Button is Clicked")
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
