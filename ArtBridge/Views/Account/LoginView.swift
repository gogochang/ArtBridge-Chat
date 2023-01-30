//
//  Login.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/29.
//

import SwiftUI

struct LoginView: View {
    @State private var id: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            
            Text("Art Bridge")
                .font(.title)
                .fontWeight(.heavy)
                .padding(.bottom, 200)
            
            Text("Sign In")
                .font(.title2)
                .fontWeight(.medium)
                .padding()
                .foregroundColor(.black)
            
            // 아이디 입력 Text Field
            HStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(.bottom)
                
                TextField("아이디를 입력하세요.", text: $id)
                    .frame(width:300, height: 10)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .padding(.bottom, 20)
            }
            
            // 비밀번호 입력 Text Field
            HStack {
                Image(systemName: "lock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width:30, height: 30)
                    .padding(.bottom)
                
                TextField("비밀번호를 입력하세요.", text: $password)
                    .frame(width: 300, height: 10)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .padding(.bottom, 20)

            }
            
            // 로그인 버튼
            Button(action: {
                print("Hellow Button")
            }, label: {
                Text("로그인")
                    .frame(width: 80, height: 10)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
            })
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
