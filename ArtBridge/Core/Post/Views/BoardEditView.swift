//
//  BoardEditView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/06.
//

import SwiftUI

struct BoardEditView: View {
    
    @ObservedObject var viewModel = PostVM()
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var postData: Post
    
    // 게시글 제목, 내용 텍스트
    @State var title: String = ""
    @State var content: String = ""
    
    //이미지 Picker
    @State private var selectedImage: Image = Image(systemName: "photo")
    @State private var isHidden: Bool = true
    @State private var onPhotoLibrary = false
    @State private var selectedUiImage: UIImage? = nil
    
    //게시글의 타입을 선택하는 Picker
    @State private var selectedPicker = 0
    
    // 게시글 타입 종류
    private let postTypes = ["자유","질문"]
    
    // 내용 없음 경고창
    @State private var warningAlert: Bool = false
    @State private var wargningMessage: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            //MARK: - 상단 바 메뉴
                HStack() {
                    Button(action: {
                        print("button is clicked")
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("취소")
                            .foregroundColor(Color.red)
                    })
                    Spacer()
                    Text("글 수정하기").bold()
                    Spacer()
                    Button(action: {
                        print("edit button is clicked")
                        if (postData.title == "") {
                            warningAlert = true
                            self.wargningMessage = "제목이 없습니다."
                        } else if (postData.content == "") {
                            warningAlert = true
                            self.wargningMessage = "내용이 없습니다."
                        } else {
                            viewModel.editPost(post: postData, title: postData.title, content: postData.content, postType: postTypes[selectedPicker], image: selectedUiImage)
                            LoadingIndicator.showLoading()
                        }
                    }, label: {
                        Text("완료")
                    })
                    .alert("Error", isPresented: $warningAlert) {
                        Button("Ok") {}
                    } message: {
                        Text(wargningMessage)
                    }
                }
                .padding()
            //MARK: - 게시글의 카테고리 선택, 제목
                HStack {
                    // 게시판카테고리 선택 Picker
                    Picker("Select Choice PostType", selection: $selectedPicker) {
                        ForEach(0 ..< postTypes.count) {
                            Text(self.postTypes[$0])
                        }
                    }
                    .colorMultiply(Color.black)
                    .background(Capsule().fill(Color.white).shadow(radius: 1,x: 1,y:1))
                    .overlay(Capsule().stroke(Color.gray , lineWidth: 0.5))
                    
                    TextField("제목을 입력하세요.", text: $postData.title)
                        .padding()
                }.padding(.horizontal, 10)
                
                Divider()
            
            //MARK: - 게시글의 본문
                TextEditor(text: $postData.content).padding()
                    
            //MARK: - Picker에서 선택한 이미지 표시
                selectedImage
                    .resizable()
                    .frame(width: 100, height: 100)
                    .overlay (
                        Button(action: {
                            print("cancle Button is Clicked")
                            isHidden = true
                            selectedUiImage = nil
                        }, label: {
                            Image(systemName: "x.square.fill")
                        }),alignment: .topTrailing
                    )
                    .opacity(isHidden ? 0 : 1)
                    .padding()
                
                Spacer()
                
                Divider()
                
            //MARK: - 사진업로드 버튼
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
            }
        //MARK: - View 시작할 때
            .onAppear{
                // 게시글의 기존 카테고리 가져오기
                if let index = postTypes.firstIndex(of: postData.postType) {
                    selectedPicker = index
                }
                // 게시판의 등록된 이미지 URL을 이용하여 사진을 다시 edit창에 가져오기
                ImageService.loadImageFromUrl(postData.imageUrl) { data in
                    selectedImage = Image(uiImage: UIImage(data:data)!)
                    selectedUiImage = UIImage(data: data)
                    isHidden = false
                }
            }
        //MARK: - ViewModel에서 게시글 수정이 완료하면 실행
            .onReceive(viewModel.$didEditPost) { success in
                if success {
                    viewModel.didEditPost = false
                    // 현재 게시글의 이미지URL을 수정된 URL을 다시 할당
                    postData.imageUrl = viewModel.imageUrl
                    presentationMode.wrappedValue.dismiss()
                    LoadingIndicator.hideLoading()
                }
            }
    }
}

//struct BoardEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardEditView()
//    }
//}
