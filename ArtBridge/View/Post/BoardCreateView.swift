//
//  PostCreateView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/05.
//

import SwiftUI

struct BoardCreateView: View {
    
    @EnvironmentObject var postVM: PostVM
    @Environment(\.presentationMode) var presentationMode
    
    var postData: Datum?
    
    @State var title: String = ""
    @State var content: String = ""
    
    
    
    var body: some View {
        VStack() {
            TextField("제목을 입력하세요.", text: $title)
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
                    if let postData = postData {
                        print("chang1")
                        postVM.editPostData(title: title,
                                            contents: content,
                                            author: postData.attributes.author,
                                            id: postData.id)
                    } else {
                        print("chang2")
                        postVM.createPostData(title: title,
                                              contents: content,
                                              author: "changgyu")
                    }
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
    init() {
        print("BoardCreateView - init(title,content) called")
        self.postData = nil
    }

    init(postData: Datum) {
        print("BoardCreateView - init(posetData) called")
        self.postData = postData
        self._title = State<String>(initialValue: postData.attributes.title)
        self._content = State<String>(initialValue: postData.attributes.contents)
    }
}

//struct BoardCreateView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardCreateView()
//    }
//}
