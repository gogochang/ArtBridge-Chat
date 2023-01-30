//
//  MyPageView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/30.
//

import SwiftUI

struct MyPageView: View {
    @State private var showModal = false
    
    var body: some View {
        ScrollView() {
            VStack() {
                Button(action: {
                    print("로그인 버튼이 클릭되었습니다.")
                    self.showModal = true
                    
                }) {
                    HStack() {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("로그인이 필요합니다.")
                        Spacer()
                    }.foregroundColor(Color.black)
                }//Button
                .sheet(isPresented: self.$showModal) {
                    LoginView()
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
