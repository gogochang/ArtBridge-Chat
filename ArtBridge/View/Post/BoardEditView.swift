//
//  BoardEditView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/06.
//

import SwiftUI

struct BoardEditView: View {
    
    @EnvironmentObject var postVM: PostVM
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var postData: Datum
    
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
                    Text("글 수정하기")
                    Spacer()
                    Button(action: {
                        print("button is clicked")
                        postVM.editPostData(title: postData.attributes.title,
                                            contents: postData.attributes.contents,
                                            author: postData.attributes.author,
                                            id: postData.id)
                        presentationMode.wrappedValue.dismiss()
                        
                    }, label: {
                        Text("완료")
                    })
                }
                .padding()
                TextField("제목을 입력하세요.", text: $postData.attributes.title)
                    .padding()
                Divider()
                TextField("내용을 입력하세요.", text: $postData.attributes.contents)
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
