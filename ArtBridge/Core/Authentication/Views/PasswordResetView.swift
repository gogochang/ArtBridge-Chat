//
//  PasswordResetView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/31.
//

import SwiftUI
import Firebase

struct PasswordResetView: View {
    @ObservedObject var userVM = UserVM()
    
    @State private var email: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            Text("비밀번호 재설정")
                .font(.largeTitle)
                .bold()
                .padding()
            
            TextField("Email", text: $userVM.email)
                .padding()
            
            Button(action: userVM.resetPassword) {
                Text("로그인")
                    .font(.system(size:20, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background( userVM.email == "" ?  Color(.systemGray5) : Color(.systemOrange))
                    .cornerRadius(16)
                    .shadow(radius: 3, x:1, y:1)
            }
            .padding()
            .disabled( userVM.email == "" )
        }
        .alert(isPresented: $userVM.showAlert) {
            Alert(title: Text("비밀번호 재설정"), message: Text(userVM.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
