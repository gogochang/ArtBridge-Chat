//
//  PostListView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/03.
//

import SwiftUI

struct BoardListView: View {
    @State var posts = [Post]()
    
    @State var firstNavigationLinkActive: Bool = false
    
    @EnvironmentObject var userVM : UserVM
    
    @ObservedObject var viewModel = PostVM()
    
    var body: some View {
        NavigationView {
            VStack() {
                HStack() {
                    Text("홈")
                        .fontWeight(.heavy)
                        .font(.title3)
                    Spacer()
                    NavigationLink(destination: BoardCreateView(), label: {
                        HStack() {
                            Image(systemName: "pencil.line")
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.black)
                    })
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                Divider()
                
                HStack() {
                    Text("자유게시판")
                        .fontWeight(.heavy)
                    Text("질문게시판")
                        .opacity(0.5)
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                
                //MARK: - 게시판 List Layout
                
                    List(posts) { post in
                        
                        ZStack() {
                            HStack() {
                                VStack() {
                                    HStack {
                                        Text(post.title)
                                            .bold()
                                            .font(.system(size:15))
                                        Spacer()
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                                    
                                    HStack() {
                                        Text(post.author)
                                        Text(post.timestamp.dateValue().toString().components(separatedBy: " ")[0])
                                        Text("댓글 0")
                                        Spacer()
                                    }
                                    .opacity(0.7)
                                    .font(.system(size: 13))
                                }//VStack
                                Spacer()
                                Image("umbagog")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(12)
                            }//HStack
                            // List 우측 화살표 없애기
                            NavigationLink(destination: BoardView(postData: post), label: {
                            })// Navigation
                            .opacity(0)
                        }
                    
                    }
                    .listStyle(PlainListStyle())
                    .onAppear(perform : {viewModel.fetchPosts()})
                    .onReceive(viewModel.$posts, perform: {self.posts = $0})
               
            }//VStack
        }
    }
    
}//BoardListView

struct BoardListView_Previews: PreviewProvider {
    static var previews: some View {
        BoardListView()
    }
}
