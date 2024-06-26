//
//  MyPageView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/30.
//
import Foundation
import SwiftUI
import Combine
import Kingfisher

struct MyPageView: View {
    @State private var showModal = false
    @State private var showingAlert = false
    @State private var showingRemoveAlert = false
    
    @State private var email: String?
    @State private var username: String?
    @State private var url: String = ""
    @State private var profileImg: UIImage? = UIImage(systemName: "person.circle")
    @State private var isLogged: Bool = false
    
    //Image Picker
    @State private var onPhotoLibrary = false
    @State private var presentsImagePicker = false
    @EnvironmentObject var userVM : UserVM
    
    // 프로필
    @EnvironmentObject var profileVM: ProfileVM
    @State private var presentsProfileView: Bool = false
    
    @State var selection: Int = 0
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text("마이 페이지")
                    .fontWeight(.heavy)
                    .font(.title3)
                    
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 8, trailing: 10))
            
            Divider()
            
            ScrollView() {
                VStack() {
                    HStack(alignment:.top) {
                        Button(action: {
                            self.showModal = true
                        }) {
                            HStack() {
                                // 프로필 이미지
                                if let profileUrl = userVM.currentUser?.profileUrl {
                                    KFImage(URL(string:profileUrl))
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .overlay {
                                            Circle().stroke(.white, lineWidth: 2)
                                        }.shadow(radius: 2)
                                }
                                VStack(alignment: .leading) {
                                    Text(userVM.currentUser?.username ?? "로그인이 필요합니다.").bold()
                                    Text(userVM.currentUser?.email ?? "")
                                }
                                Spacer()
                            }.foregroundColor(Color.black)
                        }//Button
                        .disabled(isLogged)
                        Spacer()
                        Button(action: {
                            print("프로필 설정 버튼 클릭되었습니다.")
                            profileVM.uid = userVM.currentUser?.uid
                            presentsProfileView = true
                        }) {
                            Image(systemName: "gearshape")
                                .foregroundColor(Color.black)
                        }
                        .opacity(isLogged ? 1 : 0 )
                    } //HStack
                    .padding()
                    .sheet(isPresented: self.$showModal) {
                        LoginView(showModal: $showModal, isLogged: $isLogged)
                    }
                    .sheet(isPresented: $onPhotoLibrary) {
                        // 이미지 선택
                        ImagePicker(sourceType: .photoLibrary) { pickedImage in
                            LoadingIndicator.showLoading()
                            // 선택된 이미지 Storage에 업로드
                            ImageService.uploadImage(image: pickedImage) { url in
                                //업로드된 이미지의 url을 유저정보에 새롭게 업데이트
                                userVM.updateUser(displayName: nil, profileUrl: url)
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
                    //                .disabled(!isLogged)
                    
                    Divider()
                    // 계정설정 Button
                    Button(action: {
                        showingRemoveAlert = true
                    }) {
                        HStack() {
                            Text("계정 삭제")
                            Spacer()
                        }
                    }
                    .alert(isPresented: $showingRemoveAlert) {
                        Alert(
                            title: Text("계정삭제"),
                            message: Text("계정삭제 하시겠습니까?"),
                            primaryButton: .default(Text("No"), action: {}),
                            secondaryButton: .destructive(Text("Yes"), action: {
                                isLogged = false
                                userVM.removeUser()
                            })
                        )
                    }
                    .disabled(!isLogged)
                    .padding()// 계정설정 Button
                    Divider()
                    
                    //로그아웃 Button
                    Button(action: {
                        print("로그아웃 버튼 클릭되었습니다.")
                        print(showingAlert)
                        showingAlert = true
                    }, label: {
                        Text("로그아웃")
                        Spacer()
                    })
                    .padding()
                    
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("로그아웃"),
                            message: Text("로그아웃을 하시겠습니까?"),
                            primaryButton: .default(Text("No"), action: {}),
                            secondaryButton: .destructive(Text("Yes"), action: {
                                isLogged = false
                                userVM.logOut()
                            })
                        )
                    }
                    .disabled(!isLogged)
                }
            }//ScrollView
        }
        .onReceive(userVM.$data) { data in
            print("MyPAgeView - onReceive() called")
            self.profileImg = UIImage(data: data) ?? UIImage(systemName: "person.circle")
        }
        .onReceive(userVM.$didUpdateUser) { success in
            if success {
                userVM.didUpdateUser = false
                LoadingIndicator.hideLoading()
            }
        }
        .fullScreenCover(isPresented: $presentsProfileView) {
            NavigationView {
                ProfileView(profileUser: userVM.currentUser ?? nil, selection: $selection, isSetting: true)
            }
        }
    }
}

//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView()
//    }
//}
