//
//  CommentEditView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/15.
//

import SwiftUI

struct CommentEditView: View {
//    @ObservedObject var viewModel = PostVM()
    @EnvironmentObject var viewModel: PostVM
    @Environment(\.presentationMode) var presentationMode

    @State var postData: Post
    @State var comment: Comment
    @State var commentText: String = ""
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
                    viewModel.editComment(post: postData, comment: comment, content: comment.comment)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("완료")
                })
            }// HStack
            .padding()
            
            TextEditor(text: $comment.comment)
                .frame(height: UIScreen.main.bounds.height / 3, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.black, lineWidth: 2)
                )
                .padding()
            Spacer()
        }// VStack
    }//body
}

//struct CommentEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentEditView()
//    }
//}
