//
//  PostCreateView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/05.
//

import SwiftUI

struct BoardCreateView: View {
    
    @EnvironmentObject var postVM: PostVM
    @EnvironmentObject var userVM: UserVM
    
    @Environment(\.presentationMode) var presentationMode
    
//    var postData: Datum
    
    @State var title: String = ""
    @State var content: String = ""
    
    var body: some View {
        VStack() {
            TextField(userVM.loggedInUser?.user.username ?? "제목을 입력하세요.", text: $title)
                .padding()
            Divider()
            TextField("내용을 입력하세요.", text: $content)
                .padding()
            Spacer()
        }
        .overlay(
            HStack() {
                Spacer()
                Button(action: {
                    print("BoardCreateView - Button Clicked")
                    postVM.createPostData(title: title,
                                          contents: content,
                                          author: userVM.loggedInUser?.user.username ?? "익명")
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

//struct BoardCreateView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardCreateView()
//    }
//}
