//
//  PostView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/01.
//

import SwiftUI

struct PostView: View {
    var author: String = "작성자"
    var createData: String = "2023-02-01"
    var title: String = "게시글의 제목이 들어가는 자리입니당"
    var like: Int = 0
    var ripple: Int = 0
    
    @EnvironmentObject var postVM : PostVM
    
    var body: some View {
        VStack() {
            Spacer()
            Button(action: {
                print("테스트버튼 클릭됨")
                postVM.fetchPostData()
            }, label: {
                Text("테스트")
            })
            HStack() {
                Text(author) 
                Text(createData)
                    .foregroundColor(.gray)
                Spacer()
                
                Image(systemName: "heart")
                Text(String(like))
                Image(systemName: "message")
                Text(String(ripple))
            }.font(.system(size: 13))
            Spacer()
            
            HStack() {
                Text(title)
                    .bold()
                Spacer()
            }.font(.system(size: 15))
            Spacer()
        }
        .frame(height:70)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

#if DEBUG
struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
#endif
