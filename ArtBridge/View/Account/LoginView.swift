//
//  Login.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/29.
//

import SwiftUI
import Combine
import Alamofire

struct LoginView: View {
    
    var subscription = Set<AnyCancellable>()
    @Binding var showModal: Bool
    
    @State private var id: String = ""
    @State private var password: String = ""
    @State var tag:Int? = nil
    
    @State fileprivate var shouldShowAlert : Bool = false
    
    var disabledButton: Bool = true
    
    var userVM = UserVM()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: RegisterView(), tag: 1, selection: self.$tag ) {
                    EmptyView()
                }
                Spacer()
                Text("ART BRIDGE")
                    .font(.system(size: 30))
                    .fontWeight(.heavy)
                    .padding()
                    .foregroundColor(.orange)
                
                Spacer()
                Group {
                    // 아이디 입력 Text Field
                    HStack{
                        Text("이름")
                            .bold()
                        Spacer()
                    }
                    TextField("아이디를 입력하세요.", text: $id)
                        .frame(width:300, height: 10)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .padding(.bottom, 20)
                    
                    HStack{
                        Text("비밀번호")
                            .bold()
                        Spacer()
                    }
                    // 비밀번호 입력 Text Field
                    TextField("비밀번호를 입력하세요.", text: $password)
                        .frame(width: 300, height: 10)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .padding(.bottom, 20)
                }//Group
                
                Button(action: {
                    print("Hellow Button id: \(id), password: \(password)")
                    userVM.login(userName: id, password: password)
                    
                }, label: {
                    if (self.id != "") && (self.password != "") {
                        HStack() {
                            Spacer()
                            Text("로그인")
                            Spacer()
                        }
                        .frame(height: 10)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(.systemOrange))
                        .cornerRadius(10)
                    } else {
                        HStack() {
                            Spacer()
                            Text("로그인")
                            Spacer()
                        }
                        .frame(height: 10)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                    }
                })//로그인 Button
    
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .onReceive(userVM.registrationSuccess, perform: {
                    print("LoginView - loginSuccess() called")
                    self.shouldShowAlert = true
                    self.showModal.toggle()
                })
                
                HStack() {
                    Spacer()
                    Button(action:{}) {
                        Text("비밀번호 찾기")
                    }
                    Text("|")
                    Button(action:{
                        self.tag = 1
                    }) {
                        Text("회원가입")
                    }
                    Spacer()
                }.foregroundColor(Color.gray)
                Spacer()
                Group {
                    // 카카오 로그인 버튼
                    KakaoLoginView()
                    NaverLoginView()
                    FaceBookLoginView()
                    AppleLoginView()
                    
                }//Group
                Spacer()
            }//VStack
        }//NavigationView
    }
}

//struct Login_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
