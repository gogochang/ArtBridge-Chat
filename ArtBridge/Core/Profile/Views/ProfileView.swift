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

    @EnvironmentObject var viewModel: ProfileVM
    @EnvironmentObject var userVM: UserVM
    
    // 탭 메뉴
    @Binding var selection: Int
    // 유저이름 변경
    @State var tempUsername: String = ""
    // 유저이름 변경 Alert 호출
    @State var isEditAlert: Bool = false
    // 프로필 세팅 모드
    @State var isSetupMode: Bool = false
    
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
        // 네비게이션 커스텀 상단 버튼
        .navigationBarItems(
            // 상단 뒤로가기 버튼
            leading: Button(action: {
                print("Back Button is Clicked")
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.black)
            }),
            // 상단 설정 버튼
            trailing: Button(action: {
                if isSetupMode {
                    print("isSetupMode True")
                    viewModel.updateUser()
                } else {
                    print("isSetupMode False")
                }
                isSetupMode.toggle()
            }, label: {
                if isSetupMode {
                    Text("완료")
                        .foregroundColor(Color.black)
                } else {
                    Image(systemName: "gearshape")
                        .foregroundColor(Color.black)
                }
            }).opacity(viewModel.userProfile?.uid == userVM.currentUser?.uid ? 1 : 0))
        
        .onAppear(perform: {
            // Profile View가 렌더링 되면 프로필에 표시할 유저를 가져오기
            viewModel.fetchUser()
        })
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
    // 프로필 정보
    var Profile: some View {
        VStack {
            ProfileImage // 프로필 이미지
            UserName // 프로필 유저이름
        }
    }
    
    //프로필 이미지
    var ProfileImage: some View {
        KFImage(URL(string:viewModel.userProfile?.profileUrl ?? ""))
            .resizable()
            .frame(width: 150, height: 150)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
    
    // 프로필 유저네임
    var UserName: some View {
        ZStack {
            Text(viewModel.userProfile?.username ?? "")
                .font(.title)
            Group {
                Divider()
                    .frame(minHeight: 2)
                    .overlay(Color(.systemGray))
                    .offset(y: 20)
                HStack {
                    Spacer()
                    Button(action: {
                        print("SendButton is Clicked")
                        tempUsername = viewModel.userProfile?.username ?? ""
                        isEditAlert = true
                    }, label: {
                        Image(systemName: "pencil.line")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(.systemGray))
                    })
                }
            }
            .padding(.horizontal, 16)
            .opacity(isSetupMode ? 1 : 0)
        }
        //  프로필 유저네임 편집 Alert 창
        .alert("Edit UserName", isPresented: $isEditAlert) {
            TextField("Username", text: $tempUsername)
                .textInputAutocapitalization(.never)
            Button("OK", action: {
                viewModel.userProfile?.username = tempUsername
            })
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please enter your username and password.")
        }
    }
    
    // 채팅 버튼
    var chatButton: some View {
        Button(action: {
            // TODO: 해당 유저와 1:1 채팅 View로 이동
            viewModel.createChat()
            presentationMode.wrappedValue.dismiss()
            selection = 1
        }, label: {
            VStack {
                Image(systemName: "bubble.left")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("채팅하기")
            }.foregroundColor(Color.black)
        }).opacity(viewModel.userProfile?.uid == userVM.currentUser?.uid ? 0 : 1)
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
