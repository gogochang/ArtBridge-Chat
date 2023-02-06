//
//  PostListView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/03.
//

import SwiftUI

struct BoardListView: View {
    @State var posts : [Datum] = []
    
    @State var firstNavigationLinkActive: Bool = false
    
    @EnvironmentObject var postVM : PostVM
    
    var body: some View {
        VStack() {
            //MARK: - 게시판 List Layout
            List(posts) { aPost in
                NavigationLink(destination: BoardView(postData: aPost), label: {
                    VStack() {
                        HStack() {
                            Text(aPost.attributes.author)
                            Text(aPost.attributes.createdAt.components(separatedBy: "T")[0])
                            Spacer()
                            Image(systemName: "hand.thumbsup")
                            Text("0")
                            Image(systemName: "message")
                            Text("0")
                        }
                        .font(.system(size: 13))
                        
                        HStack {
                            Text(aPost.attributes.title)
                                .bold()
                                .font(.system(size:15))
                            Spacer()
                        }
                    }//VStack
                }) //Navigation
            }//List
            .onAppear(perform : {postVM.fetchPostData()})
            .onReceive(postVM.$posts, perform: {self.posts = $0})
        }//VStack
        //MARK: - 하단 글쓰기 버튼
        .overlay(
            HStack() {
                Spacer()
                NavigationLink(destination: BoardCreateView(), label: {
                    HStack() {
                        Image(systemName: "square.and.pencil")
                    }
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.white)
                    .background(Color.orange)
                    .cornerRadius(15)
                    .padding()
                })
            }
            ,alignment: .bottom
        )//overlay
        
    }
    
}//BoardListView

struct BoardListView_Previews: PreviewProvider {
    static var previews: some View {
        BoardListView()
    }
}
