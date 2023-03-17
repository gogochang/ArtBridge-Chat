//
//  PostListView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/03.
//

import SwiftUI
import Kingfisher

struct BoardListView: View {
    @State var posts = [Post]()
    
    @State var firstNavigationLinkActive: Bool = false
    @State var previewImage: UIImage?
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
                    Button(action: {
                        print("전체 게시판 버튼 클릭")
                        viewModel.postType = PostVM.PostType.all
                    }, label: {
                        Text("전체")
                    })
                    .buttonStyle(CapsuleButtonStyle(selected: viewModel.postType == .all))
                    
                    Button(action: {
                        print("자유게시판 버튼 클릭")
                        viewModel.postType = PostVM.PostType.free
                    }, label: {
                        Text("자유게시판")
                    })
                    .buttonStyle(CapsuleButtonStyle(selected: viewModel.postType == .free))
                    
                    Button(action: {
                        print("질문게시판 버튼 클릭")
                        viewModel.postType = PostVM.PostType.question
                    }, label: {
                        Text("질문게시판")
                    })
                    .buttonStyle(CapsuleButtonStyle(selected: viewModel.postType == .question))
                    
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
                                if let url = post.imageUrl {
                                    KFImage(URL(string:url))
                                        .resizable()
                                        .frame(maxWidth: 50, maxHeight: 50)
                                        .cornerRadius(12)
                                }
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

// 게시판 종류 선택버튼 스타일
struct CapsuleButtonStyle: ButtonStyle {
    var selected: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.foregroundColor(selected ? Color.black : Color.gray)
            .padding(.vertical,5).padding(.horizontal,10)
            .background(Capsule().fill(Color.white).shadow(radius: 1,x: 1,y:1))
            .overlay(Capsule().stroke(selected ? Color.black: Color.gray , lineWidth: 0.5))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}

//struct BoardListView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardListView()
//    }
//}
