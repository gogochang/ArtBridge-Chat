//
//  MyPageView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/30.
//

import SwiftUI

struct MyPageView: View {
    @State private var showModal = false
    @State var userName: String = "로그인이 필요합니다."
    @State var email: String = ""
    @State var isLogged: Bool = false
    
    @EnvironmentObject var userVM : UserVM
    
    var body: some View {
        ScrollView() {
            VStack() {
                Button(action: {
                    self.showModal = true
                }) {
                    HStack() {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text(userName)
                            Text(email)
                        }
                        Spacer()
                    }.foregroundColor(Color.black)
                }//Button
                .disabled(isLogged)
                .sheet(isPresented: self.$showModal) {
                    LoginView(showModal: $showModal, userName: $userName, email: $email, isLogged: $isLogged)
                }.padding()
                
                Divider()
                
                // 계정설정 Button
                Button(action: {
                    print("계정설정 버튼 클릭되었습니다.")
                }) {
                    HStack() {
                        Text("계정설정")
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                }.padding()// 계정설정 Button
                Divider()
                
                
            }
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
