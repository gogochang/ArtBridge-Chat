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
                VStack(alignment: .leading, spacing: 20){
                    //MARK: 이메일 입력 Text Field
                    Text("이메일")
                        .font(.system(size:20, weight: .semibold))
                              
                    TextField("이메일을 입력하세요.", text: $userVM.emailInput)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        .shadow(radius: 3,x: 1, y: 1)
                    
                    //MARK: 비밀번호 입력 Text Field
                    Text("비밀번호")
                            .font(.system(size:20, weight: .semibold))
                    SecureField("비밀번호를 입력하세요.", text: $userVM.passwordInput)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        .shadow(radius: 3,x: 1, y: 1)
                    
                    //MARK: 로그인 버튼
                    Button(action: {
                        print("Login Button is Clicked")
                        userVM.logIn()
                    }, label: {
                        Text("로그인")
                            .font(.system(size:20, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background( (userVM.emailInput == "" || userVM.passwordInput == "") ?  Color(.systemGray5) : Color(.systemOrange))
                            
                    })
                    .cornerRadius(16)
                    .shadow(radius: 3, x:1, y:1)
                    .disabled( userVM.emailInput == "" || userVM.passwordInput == "" )
                    
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
                    
                }
                .padding(.horizontal,40)
                .onReceive(userVM.$didLoginUser) { success in
                    if success {
                        print("LoginView - didLoginUser Success")
                        userVM.didLoginUser = false
                        isLogged = true
                        userVM.emailInput = ""
                        userVM.passwordInput = ""
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                Spacer()
            }//VStack
        }//NavigationView
    }
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
