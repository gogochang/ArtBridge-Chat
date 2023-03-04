//
//  KakaoLoginView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/07.
//

import SwiftUI
import KakaoSDKUser

struct KakaoLoginView: View {
    
    @EnvironmentObject var userVM : UserVM
    
    var body: some View {
        Button(action: {
            print("LoginView - Clicked kakao Button")
            userVM.kakaoLogIn()
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
            .cornerRadius(12)
        })
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        .shadow(radius: 5)
    }
}

struct KakaoLoginView_Previews: PreviewProvider {
    static var previews: some View {
        KakaoLoginView()
    }
}
