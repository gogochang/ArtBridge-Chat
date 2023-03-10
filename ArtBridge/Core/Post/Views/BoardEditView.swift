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
    
    @State var title: String = ""
    @State var content: String = ""
    
    var body: some View {
            VStack() {
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
                        viewModel.editPost(post: postData, title: postData.title, content: postData.content)
                        presentationMode.wrappedValue.dismiss()
                        
                    }, label: {
                        Text("완료")
                    })
                }
                .padding()
                TextField("제목을 입력하세요.", text: $postData.title)
                    .padding()
                Divider()
                TextField("내용을 입력하세요.", text: $postData.content)
                    .padding()
                Spacer()
            }
    }
}

//struct BoardEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardEditView()
//    }
//}
