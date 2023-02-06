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
            TextField("제목을 입력하세요.", text: $postData.attributes.title)
                .padding()
            Divider()
            TextField("내용을 입력하세요.", text: $postData.attributes.contents)
                .padding()
            Spacer()
        }
        .overlay(
            HStack() {
                Spacer()
                Button(action: {
                    print("BoardCreateView - Button Clicked")
                    postVM.editPostData(title: postData.attributes.title,
                                        contents: postData.attributes.contents,
                                        author: postData.attributes.author,
                                        id: postData.id)
                    presentationMode.wrappedValue.dismiss()

                }, label: {
                    Image(systemName: "square.and.pencil")
                })
                .frame(width: 50, height: 50)
                .foregroundColor(Color.white)
                .background(Color.orange)
                .cornerRadius(15)
                .padding()
            }
            ,alignment: .bottom
        )//overlay
    }
}

//struct BoardEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardEditView()
//    }
//}
