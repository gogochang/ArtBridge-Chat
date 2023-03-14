//
//  Login.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/29.
//

import SwiftUI
import Combine
import Alamofire
import Firebase

struct LoginView: View {
    
    @EnvironmentObject var userVM : UserVM
    
//    @ObservedObject var userVM = UserVM()
    
    @Environment(\.presentationMode) var presentationMode
    
    var subscription = Set<AnyCancellable>()
    @Binding var showModal: Bool
    @Binding var isLogged: Bool
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State var tag:Int? = nil
    @State var didLoginUser = false
    var disabledButton: Bool = true
    
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
                    .shadow(radius: 3)
                
                Spacer()
                Group {
                    // 아이디 입력 Text Field
                    HStack{
                        Text("이메일")
                            .bold()
                        Spacer()
                    }
                    TextField("이메일을 입력하세요.", text: $userVM.emailInput)
                        .frame(width:300, height: 10)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .padding(.bottom, 20)
                        .shadow(radius: 3)
                    
                    HStack{
                        Text("비밀번호")
                            .bold()
                        Spacer()
                    }
                    // 비밀번호 입력 Text Field
                    SecureField("비밀번호를 입력하세요.", text: $userVM.passwordInput)
                        .frame(width: 300, height: 10)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .padding(.bottom, 20)
                        .shadow(radius: 3)
                }//Group
                
                Button(action: {
                    print("Login Button is Clicked")
                    userVM.logIn()
                }, label: {
                    if (self.email != "") && (self.password != "") {
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
                .shadow(radius: 3)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .onReceive(userVM.$didLoginUser) { success in
                    if success {
                        print("LoginView - didLoginUser Success")
                        userVM.didLoginUser = false
                        isLogged = true
                        presentationMode.wrappedValue.dismiss()
                    }
                }
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
//                Group {
//                    // 카카오 로그인 버튼
//                    KakaoLoginView()
//                    NaverLoginView()
//                    FaceBookLoginView()
//                    AppleLoginView()
//                }//Group
                Button(action: {
                    print("chang current user -> \(userVM.currentUser)")
                    print("chang current user -> \(Auth.auth().currentUser)")
                }, label: {
                    Text("지금 유저 ?")
                })
                Spacer()
            }//VStack
        }//NavigationView
    }
    
    //
    func logIn() {
        print("LoginView - logIn() called")
        userVM.logIn()
    }
}

//struct Login_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
