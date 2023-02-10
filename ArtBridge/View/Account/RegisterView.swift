//
//  RegisterView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/07.
//

import SwiftUI
import Combine

struct RegisterView: View {
    
    @ObservedObject var registerVM = RegisterVM()

    var body: some View {
        VStack(alignment: .leading) {
            
            Spacer()
            
            //Name TextField
            Section(
                header: Text("닉네임").bold(),
                footer: Text(registerVM.userNameMessage).foregroundColor(.red).font(.system(size: 13))) {
                    TextField("닉네임을 입력하세요.", text: $registerVM.userNameInput)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                }
            
            //Email TextField
            Section(
                header: Text("이메일").bold(),
                footer: Text(registerVM.emailMessage).foregroundColor(.red).font(.system(size: 13))) {
                    TextField("이메일을 입력하세요.", text: $registerVM.emailInput)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                }
            
            //Password TextField
            Section(
                header: Text("비밀번호").bold(),
                footer: Text(registerVM.passwordMessage).foregroundColor(.red).font(.system(size: 13))) {
                    SecureField("비밀번호를 입력하세요.", text: $registerVM.passwordInput)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                    SecureField("비밀번호를 재 입력하세요.", text: $registerVM.passwordConfirmInput)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                }
            
            Spacer()
            
            //SignUp Button
            Section {
                HStack {
                    Spacer()
                    Button(action: {
                        self.signUp()
                        
                    }) {
                        Text("Sign up")
                    }.disabled(!registerVM.isValid)
                    Spacer()
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    //TODO: Login API 호출
    func signUp() {
        print("RegisterView - signUp() called")
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
