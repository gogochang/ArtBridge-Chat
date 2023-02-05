//
//  PostView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/01.
//

import SwiftUI

struct BoardView: View {
    
    @EnvironmentObject var postVM: PostVM
    @Environment(\.presentationMode) var presentationMode
    
    var postData: Datum
    
//    @State var title: String = ""
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                // 제목
                Text(postData.attributes.title)
                    .font(.system(size: 15))
                    .bold()
                    .padding([.bottom], 5)
                // 글 작성자, 날짜
                HStack() {
                    Image(systemName: "person.fill")
                    Text(postData.attributes.author)
                    Text(postData.attributes.createdAt.components(separatedBy: "T")[0]).foregroundColor(.gray)
                    Spacer()
                    
                    NavigationLink(destination: BoardCreateView(postData: postData), label: {
                        Text("수정")}
                    )
                    
                    Button(action: {
                        print(" 삭제하기 버튼 클릭 ")
                        postVM.removePostData(id: postData.id)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("삭제")
                    })
                    .foregroundColor(Color.red)
                }
                .font(.system(size:13))
                Divider()
                    .padding([.bottom], 20)
                Text(postData.attributes.contents)
                Spacer()
            }//VStack
            .padding()
            Spacer()
        }//HStack
    }
}

#if DEBUG
//struct BoardView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardView(postData: Datum(
//            id: 0, attributes: Attributes(
//                title: "제목입니다. 동해물과 백두산이 마르고 ",
//                contents: "내용입니다.",
//                author: "작성자",
//                createdAt: "2023-01-01",
//                updatedAt: "2023-01-02",
//                publishedAt: "2-23=-1=-1")))
//    }
//}
#endif
