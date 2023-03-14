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
//            userVM.kakaoLogIn()
        }, label: {
                Image("kakao_login_large_wide")
        })
    }
}

struct KakaoLoginView_Previews: PreviewProvider {
    static var previews: some View {
        KakaoLoginView()
    }
}
