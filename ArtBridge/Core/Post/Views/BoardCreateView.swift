//
//  PostCreateView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/05.
//

import SwiftUI

struct BoardCreateView: View {
    
    @State var didUploadPost = false
    
    @State private var presentsImagePicker = false
    @State private var onPhotoLibrary = false
    @State private var selectedImage: Image = Image(systemName: "photo")
    @State private var selectedUiImage: UIImage? = nil
    @ObservedObject var viewModel = PostVM()
    @EnvironmentObject var userVM: UserVM
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isHidden: Bool = true
    @State private var isDisabled: Bool = false
    
    @State var title: String = ""
    @State var content: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                TextField(userVM.loggedInUser?.user.username ?? "제목을 입력하세요.", text: $title)
                    .padding()
                
                Divider()
                
                TextEditor(text: $content)
                    .padding()
                
                selectedImage
                    .resizable()
                    .frame(width: 100, height: 100)
                    .overlay (
                        Button(action: {
                            print("cancle Button is Clicked")
                            isHidden = true
                        }, label: {
                            Image(systemName: "x.square.fill")
                        }),alignment: .topTrailing
                    )
                    .opacity(isHidden ? 0 : 1)
                    .padding()
                
                Spacer()
                
                Divider()
                
                HStack() {
                    Button(action: {
                        print("adding Photo Button is Clicked")
                        onPhotoLibrary = true
                        
                    }, label: {
                        HStack() {
                            Image(systemName: "photo")
                            Text("사진")
                        }
                    })//Button
                    .foregroundColor(Color.black)
                    .sheet(isPresented: $onPhotoLibrary) {
                        ImagePicker(sourceType: .photoLibrary) { (pickedImage) in
                            selectedImage = Image(uiImage: pickedImage)
                            selectedUiImage = pickedImage
                            isHidden = false
                        }
                    }
                    Spacer()
                }//HStack
                // 사진 앨범 선택
                .padding()
            }// VStack
        }// NavigationView
        .navigationTitle("작성하기")
        .navigationBarBackButtonHidden(true)
        // 게시판 작성 취소 버튼
        .navigationBarItems(leading: Button(action: {
            print("Cancle Button is Clicked")
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("취소")
                .foregroundColor(Color.red)
        }))
        // 게시판 작성 완료 버튼
        .navigationBarItems(trailing: Button(action: {
            print("Success Button is Clicked")
            LoadingIndicator.showLoading()
            isDisabled = true
            viewModel.uploadPost(title: title, content: content, image: selectedUiImage)
        }, label: {
            Text("완료")
        })).disabled(isDisabled)
        .onReceive(viewModel.$didUploadPost) { success in
            if success {
                viewModel.didUploadPost = false
                isDisabled = false
                LoadingIndicator.hideLoading()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

//struct BoardCreateView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardCreateView()
//    }
//}
