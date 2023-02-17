//
//  MyPageView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/30.
//
import Foundation
import SwiftUI
import Combine

struct MyPageView: View {
    @State private var showModal = false
    @State private var showingAlert = false
    
    @State private var email: String = "a"
    @State private var username: String = ""

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
                            Text(self.userVM.currentUser?.email ?? "로그인필요")
//                            Text(self.userVM.currentUser?.email ?? "")
                        }
                        Spacer()
                    }.foregroundColor(Color.black)
                }//Button
                .disabled(isLogged)
                .sheet(isPresented: self.$showModal) {
                    LoginView(showModal: $showModal, isLogged: $isLogged)
                }.padding()
                
                Divider()
                
                // 계정설정 Button
                Button(action: {
                    print("계정설정 버튼 클릭되었습니다.")
                }) {
                    HStack() {
                        Text("계정설정")
                        Spacer()
                    }
                }
                .disabled(!isLogged)
                .padding()// 계정설정 Button
                Divider()
                
                //로그아웃 Button
                Button(action: {
                    print("로그아웃 버튼 클릭되었습니다.")
                    showingAlert = true
                }, label: {
                    Text("로그아웃")
                    Spacer()
                })
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("로그아웃"),
                        message: Text("로그아웃을 하시겠습니까?"),
                        primaryButton: .destructive(Text("No"), action: {}),
                        secondaryButton: .default(Text("Yes"), action: {
                            isLogged = false
                            userVM.logOut()
                        })
                    )
                }
                .disabled(!isLogged)
            }
        }//ScrollView
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
