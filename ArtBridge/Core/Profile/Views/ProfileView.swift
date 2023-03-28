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
    @Binding var profileUser: User
    // 탭 메뉴
    @Binding var selection: Int
    // 유저이름 변경
    @State var tempUsername: String = ""
    // 유저이름 변경 Alert 호출
    @State var isEditAlert: Bool = false
    // 프로필 세팅 모드
    @State var isSetupMode: Bool = false
    // 프로필 이미지 Picker
    @State private var onPhotoLibrary = false
    @State private var presentsImagePicker = false
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
                    viewModel.userProfile?.username = tempUsername
                    profileUser.username = tempUsername
                    viewModel.updateUser()
                    userVM.fetchUser()
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
        //MARK: Image Picker
        .sheet(isPresented: $onPhotoLibrary) {
            // 이미지 선택
            ImagePicker(sourceType: .photoLibrary) { pickedImage in
                LoadingIndicator.showLoading()
                // 선택된 이미지 Storage에 업로드
                ImageService.uploadImage(image: pickedImage) { url in
                    //업로드된 이미지의 url을 유저정보에 새롭게 업데이트
                    userVM.updateUser(displayName: nil, profileUrl: url)
                    profileUser.profileUrl = url
                    viewModel.fetchUser()
                }
            }
        }
        .actionSheet(isPresented: $presentsImagePicker) {
            ActionSheet(
                title: Text("이미지 선택하기"),
                message: nil,
                buttons: [
                    .default(
                        Text("사진 앨범"),
                        action: { onPhotoLibrary = true }
                    ),
                    .cancel(
                        Text("돌아가기")
                    )
                ]
            )
        }
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
            .overlay (
                Button(action: {
                    print("cancle Button is Clicked")
                    presentsImagePicker = true
                }, label: {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .frame(width: 25, height: 20)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                        .foregroundColor(Color.black)
                })
                .opacity(isSetupMode ? 1 : 0)
                ,alignment: .bottomTrailing
            )
    }
    
    // 프로필 유저네임
    var UserName: some View {
        ZStack {
            Text(profileUser.username )
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
                        tempUsername = profileUser.username
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
                profileUser.username = tempUsername
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
