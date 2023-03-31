//
//  PostListView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/03.
//

import SwiftUI
import FirebaseAuth
import Kingfisher

struct BoardListView: View {
    //게시글 목록
    @State var posts = [Post]()
    
    // 글 작성 버튼
    @State var showingNavigation: Bool = false
    @State var showingModal: Bool = false
    @State var isLogged: Bool = false
    
    //유저 ViewModel
    @EnvironmentObject var userVM : UserVM
    //게시판 ViewModel
    @ObservedObject var viewModel = PostVM()
    
    //탭 메뉴
    @Binding var selection: Int
    
    var body: some View {
        NavigationView {
            VStack() {
                HStack() {
                    Text("홈")
                        .fontWeight(.heavy)
                        .font(.title3)
                    Spacer()
                    Button(action: {
                        if let user = userVM.currentUser {
                            //로그인 되어있으면 글 작성뷰로 이동
                            showingNavigation = true
                        } else {
                            //로그인 안되어 있으면 로그인뷰로 이동
                            showingModal = true
                        }
                    }, label: {
                        HStack() {
                            Image(systemName: "pencil.line")
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.black)
                    })
                    // 로그인이 되어 있으면 게시글 작성 뷰
                    NavigationLink(destination: BoardCreateView(), isActive: $showingNavigation, label: {
                        EmptyView()
                    })
                    // 글작성 버튼 클릭 시 로그인이 안되어있으면 로그인뷰 띄우기
                    .sheet(isPresented: self.$showingModal) {
                        LoginView(showModal: $showingModal, isLogged: $isLogged)
                    }
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
                        // 선택된 타입과 게시글의 타입이 일치하면 if문을 실행 
                        if(viewModel.postType.isPostTypeMatch(type: post.postType)) {
                            ZStack() {
                                HStack() {
                                    VStack() {
                                        HStack {
                                            Text(post.postType)
                                                .font(.system(size: 12))
                                                .padding(.vertical,5).padding(.horizontal,10)
                                                .background(Capsule().fill(Color(.systemGray6)))
                                            Text(post.title)
                                                .bold()
                                                .font(.system(size:15))
                                            Spacer()
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                                        
                                        HStack() {
                                            Text(post.user.username)
                                            Text(post.timestamp.dateValue().toString().components(separatedBy: " ")[0])
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
                                NavigationLink(destination: BoardView(postData: post, selection: $selection), label: {
                                })// Navigation
                                .opacity(0)
                            }
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
