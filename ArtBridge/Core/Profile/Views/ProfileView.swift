//
//  ProfileView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/19.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode

    // 프로필 정보
    // TODO: User 데이터를 사용하는 것으로 변경 필요
    let profileUrl: String
    let username: String
    
    //MARK: body
    var body: some View {
        VStack(spacing:20) {
            
            backgroundImage // 프로필 배경 이미지
                        
            Profile // 프로필 이미지, 유저이름
                .offset( y: -250)
                .padding(.bottom, -250)
                
            Divider()

            chatButton // 해당 유저에게 채팅하기 버튼
            
        }
        .edgesIgnoringSafeArea(.top)
        // 뒤로가기 커스텀 상단 버튼
        .navigationBarItems(
            leading: Button(action: {
                print("Back Button is Clicked")
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.black)
            }))
    }
}

private extension ProfileView {
    
    //MARK: View
    var backgroundImage: some View {
        GeometryReader {
            Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), opacity: 0.2)
                .frame(height: $0.size.height - 150)
//          TODO: 프로필 배경사진 추가 필요
//            KFImage(URL(string:"유저 프로필 배경URL"))
//                .resizable()
//                .scaledToFill()
//                .frame(height: $0.size.height - 150)
        }
    }
    
    var Profile: some View {
        VStack {
            ProfileImage // 프로필 이미지
            UserName // 프로필 유저이름
        }
    }
    
    var ProfileImage: some View {
        KFImage(URL(string:profileUrl))
            .resizable()
            .frame(width: 150, height: 150)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
        
    }
    
    var UserName: some View {
        Text(username)
            .font(.title)
    }
    
    var chatButton: some View {
        Button(action: {
            // TODO: 해당 유저와 1:1 채팅 View로 이동
        }, label: {
            VStack {
                Image(systemName: "message")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("채팅하기")
            }.foregroundColor(Color.black)
        })
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
