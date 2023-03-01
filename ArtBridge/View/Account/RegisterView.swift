//
//  RegisterView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/07.
//

import SwiftUI
import Combine

struct RegisterView: View {
    
    @ObservedObject var registerVM = RegisterVM()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var profileImage: Image = Image(systemName: "person.circle")
    @State private var presentsImagePicker = false
    @State private var onCamera = false
    @State private var onPhotoLibrary = false
    @State private var profilUiImage: UIImage? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Spacer()
            
            profileImage
                .resizable()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(radius:7)
                .padding()
                .onTapGesture {
                    presentsImagePicker = true
                }
            // 카메라 선택
                .sheet(isPresented: $onCamera) {
                    ImagePicker(sourceType: .camera) { (pickedImage) in
                        profileImage = Image(uiImage: pickedImage)
                        profilUiImage = pickedImage
                    }
                }
            // 사진 앨범 선택
                .sheet(isPresented: $onPhotoLibrary) {
                    ImagePicker(sourceType: .photoLibrary) { (pickedImage) in
                        profileImage = Image(uiImage: pickedImage)
                        profilUiImage = pickedImage
                    }
                }
                .actionSheet(isPresented: $presentsImagePicker) {
                    ActionSheet(
                        title: Text("이미지 선택하기"),
                        message: nil,
                        buttons: [
                            .default(
                                Text("카메라"),
                                action: { onCamera = true }
                            ),
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
            
            //Name TextField
            Section(
                header: Text("닉네임").bold(),
                footer: Text(registerVM.userNameMessage).foregroundColor(.red).font(.system(size: 13))) {
                    TextField("닉네임을 입력하세요.", text: $registerVM.userNameInput)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                }

            //Email TextField
            Section(
                header: Text("이메일").bold(),
                footer: Text(registerVM.emailMessage).foregroundColor(.red).font(.system(size: 13))) {
                    TextField("이메일을 입력하세요.", text: $registerVM.emailInput)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                }
            
            //Password TextField
            Section(
                header: Text("비밀번호").bold(),
                footer: Text(registerVM.passwordMessage).foregroundColor(.red).font(.system(size: 13))) {
                    SecureField("비밀번호를 입력하세요.", text: $registerVM.passwordInput)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                    SecureField("비밀번호를 재 입력하세요.", text: $registerVM.passwordConfirmInput)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                }
            
            Spacer()
            
            //SignUp Button
            Section {
                HStack {
                    Spacer()
                    Button(action: {
                        registerUser()
                    }) {
                        Text("Sign up")
                    }.disabled(!registerVM.isValid)
                    Spacer()
                }
            }
            .onReceive(registerVM.registrationSuccess, perform: {
                print("registerVM - Registration Success")
                presentationMode.wrappedValue.dismiss()
            })
            
            Spacer()
        }
        
        .padding()
    }
    
    func registerUser() {
        print("RegisterView - signUp() called")
        registerVM.registerUser()
        FirebaseService.uploadImage(image: profilUiImage?.jpegData(compressionQuality: 0.5), imageName: "profileImage_\(registerVM.emailInput)")
    }
}

//struct RegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterView()
//    }
//}
