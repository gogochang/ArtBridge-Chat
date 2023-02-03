//
//  PostListView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/03.
//

import SwiftUI

struct PostListView: View {
    @State  var posts : [Datum] = []
    
    @EnvironmentObject var postVM : PostVM
    
    var body: some View {
        VStack() {
            List(posts) { aPost in
                HStack() {
                    Text(aPost.attributes.title)
                    Text(aPost.attributes.contents)
                }
            }//List(posts)
            .onAppear(perform : {postVM.fetchPostData()})
            .onReceive(postVM.$posts, perform: {self.posts = $0})
            HStack() {
                Button(action: {
                  print("Wirte Button Clicked")
                }, label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 25, height: 25)
                })
                .padding()
                Spacer()
            }//HStack
        }//VStack
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView()
    }
}
