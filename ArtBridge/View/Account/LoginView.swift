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
                    Text("이메일")
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
                print("Hellow Button")
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
            })
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))

            HStack() {
                Spacer()
                Button(action:{}) {
                    Text("아이디 찾기")
                }
                Text("|")
                Button(action:{}) {
                    Text("비밀번호 찾기")
                }
                Spacer()
            }.foregroundColor(Color.gray)
            Spacer()
            Group {
                // 카카오 로그인 버튼
                Button(action: {
                    print("LoginView - Clicked kakao Button")
                }, label: {
                    HStack() {
                        Spacer()
                        Text("카카오로 시작")
                        Spacer()
                    }
                    .frame(height: 10)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.systemYellow))
                    .cornerRadius(10)
                })
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                Button(action: {
                    print("LoginView - Clicked Naver Button")
                }, label: {
                    HStack() {
                        Spacer()
                        Text("네이버로 시작")
                        Spacer()
                    }
                    .frame(height: 10)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.systemGreen))
                    .cornerRadius(10)
                })
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                Button(action: {
                    print("LoginView - Clicked FaceBook Button")
                }, label: {
                    HStack() {
                        Spacer()
                        Text("페이스북으로 시작")
                        Spacer()
                    }
                    .frame(height: 10)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                })
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                Button(action: {
                    print("LoginView - Clicked Apple Button")
                }, label: {
                    HStack() {
                        Spacer()
                        Text("Apple로 시작")
                        Spacer()
                    }
                    .frame(height: 10)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                })
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }//Group
            Spacer()
            Button(action:{}) {
                Text("회원가입")
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
