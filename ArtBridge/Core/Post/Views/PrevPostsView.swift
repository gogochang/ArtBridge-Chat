//
//  PrevPostsView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/30.
//

import SwiftUI

struct PrevPostsView: View {
    var body: some View {
        VStack() {
            Spacer()
            HStack() {
                Text("작성자")
                    
                Text("00분전")
                    .foregroundColor(.gray)
                Spacer()
                Image(systemName: "heart")
                Text("1")
                Image(systemName: "message")
                Text("2")
            }.font(.system(size: 13))
            Spacer()
            
            HStack() {
                Text("게시글의 제목이 들어가는 자리입니다.")
                    .bold()
                Spacer()
            }.font(.system(size: 15))
            Spacer()
        }
        .frame(height:70)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        
        Divider()
    }
}

struct PrevPostsView_Previews: PreviewProvider {
    static var previews: some View {
        PrevPostsView()
    }
}
