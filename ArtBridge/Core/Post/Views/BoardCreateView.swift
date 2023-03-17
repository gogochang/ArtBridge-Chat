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
    
    //게시글의 타입을 선택하는 Picker
    @State private var selectedPicker = 0
    // 게시글 타입 종류
    private let PostTypes = ["자유","질문"]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack() {
                    
                    // 게시판카테고리 선택 Picker
                    Picker("Select Choice PostType", selection: $selectedPicker) {
                        ForEach(0 ..< PostTypes.count) {
                            Text(self.PostTypes[$0])
                        }
                    }
                    .colorMultiply(Color.black)
                    .background(Capsule().fill(Color.white).shadow(radius: 1,x: 1,y:1))
                    .overlay(Capsule().stroke(Color.gray , lineWidth: 0.5))
                    
                    // 제목입력 TextField
                    TextField(userVM.loggedInUser?.user.username ?? "제목을 입력하세요.", text: $title)
                }.padding(.horizontal, 10)
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
                        .foregroundColor(Color.black)
                        .padding(.vertical,5).padding(.horizontal,10)
                        .background(Capsule().fill(Color.white).shadow(radius: 1,x: 1,y:1))
                    })//Button
                    .overlay(Capsule().stroke(Color.gray , lineWidth: 0.5))
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
            viewModel.uploadPost(title: title, content: content, postType: PostTypes[selectedPicker], image: selectedUiImage)
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
