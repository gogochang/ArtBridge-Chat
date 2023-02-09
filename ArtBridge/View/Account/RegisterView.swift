//
//  RegisterView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/07.
//

import SwiftUI
import Combine

struct RegisterView: View {
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var checkPassword: String = ""
    @State var isHidden: Bool = true
    
    @ObservedObject var registerVM = RegisterVM()

    var body: some View {
        VStack(alignment: .leading) {
            
            Spacer()
            Section(header: Text("닉네임").bold()) {
                TextField("닉네임을 입력하세요.", text: $name)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
            }
            Section(header: Text("이메일").bold()) {
                TextField("이메일을 입력하세요.", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
            }
            Section(header: Text("비밀번호").bold()) {
                TextField("비밀번호를 입력하세요.", text: $registerVM.passwordInput)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                
                if registerVM.isHidden {
                    Text("비밀번호가 일치하지 않습니다.")
                        .foregroundColor(Color.red)
                        .font(.system(size:13))
                        .hidden()
                } else {
                    Text("비밀번호가 일치하지 않습니다.")
                        .foregroundColor(Color.red)
                        .font(.system(size:13))
                }
                    
            }
            Section(header: Text("비밀번호 재확인").bold()) {
                TextField("비밀번호를 재 입력하세요.", text: $registerVM.passwordConfirmInput)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
            }
            Spacer()
            HStack() {
                Spacer()
                Button(action: {
                    print("회원가입 버튼 클릭")
                }, label: {
                    Text("회원가입")
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color(.systemOrange))
                        .cornerRadius(15)
                })
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
