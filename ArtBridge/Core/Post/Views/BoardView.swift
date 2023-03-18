//
//  PostView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/01.
//

import SwiftUI
import FirebaseAuth
import Kingfisher

struct BoardView: View {
    
    @EnvironmentObject var viewModel: PostVM
    @Environment(\.presentationMode) var presentationMode
    
    // 댓글 TextField
    @State private var commentText: String = ""
    
    // 권한 경고창
    @State private var warningAlert: Bool = false
    
    // 게시판 추가 메뉴
    @State private var presentsAlert: Bool = false
    @State private var presentsBoardEditor: Bool = false
    // 댓글 추가 메뉴
    @State private var presentsCommentAlert: Bool = false
    @State private var presentsCommentEditor: Bool = false
    @State var postData: Post
    
    @State var comments = [Comment]()
    @State var currentComment: Comment?
    
    var body: some View {
        NavigationView {
            VStack() {
                ScrollView() {
                    VStack(alignment: .leading) {
                        //MARK: - 게시그 제목
                        Text(postData.title)
                            .font(.title3)
                            .bold()
                            .padding([.bottom], 5)
                        
                        //MARK: - 글 작성자, 날짜
                        HStack() {
                            KFImage(URL(string:postData.profileUrl))
                                .resizable()
                                .frame(maxWidth: 25, maxHeight: 25)
                                .clipShape(Circle())
                                .overlay { Circle().stroke(.white, lineWidth: 1) }
                                .shadow(radius: 1)
                            
                            VStack(alignment: .leading) {
                                Text(postData.author).bold()
                                HStack() {
                                    Text(postData.timestamp.dateValue().toString().components(separatedBy: " ")[0])
                                    Text("조회 0")
                                }.opacity(0.7)
                            }
                            Spacer()
                        }// HStack
                        .font(.system(size:13))
                        .padding([.bottom], 5)
                        
                        Divider()
                        
                        //MARK: - 게시글 내용
                        Text(postData.content).padding(.vertical,20)
                        
                        //MARK: - 게시글 이미지
                        if "" != postData.imageUrl {
                            KFImage(URL(string:postData.imageUrl))
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                                .padding(EdgeInsets(top: 50, leading: 0, bottom: 50, trailing: 0))
                        }
                        //MARK: - 댓글 Group
                        Group {
                            commentList
                        }
                    }//VStack
                    .padding()
                    Spacer()
                }// ScrollView
                // 댓글 입력창 TextField 설정
                ZStack(alignment: .trailing) {
                    TextField("댓글을 입력하세요", text: $commentText)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                        .cornerRadius(16)
                    
                    // Button에 이미지 추가
                    Button(action: {
                        print("SendButton is Clicked")
                        guard let user = Auth.auth().currentUser else { return }
                        viewModel.addComment(post: postData, comment: commentText)
                        self.commentText = ""
                    }, label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.trailing, 16)
                            .frame(width: 40, height: 40)
                    })
                }.padding(.horizontal,10)
            }
        }
        //MARK: - Navigation 상단메뉴
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        //Navigation 상단 아이템
        .navigationBarItems(
            // 뒤로가기 커스텀 상단 버튼
            leading: Button(action: {
            print("Back Button is Clicked")
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(Color.black)
        }),
            // 더보기 상단 버튼
            trailing: Button(action: {
            print("Success Button is Clicked")
                if postData.uid == Auth.auth().currentUser?.uid {
                    presentsAlert = true
                } else {
                    warningAlert = true
                }
        }, label: {
            Image(systemName: "ellipsis")
                .foregroundColor(Color.black)
        }))
        
        //MARK: - 게시글 더보기 메뉴
        .confirmationDialog("",isPresented: $presentsAlert, titleVisibility: .hidden) {
            Button("수정") {
                presentsBoardEditor = true
            }
            Button("삭제", role: .destructive) {
                viewModel.deletePost(post: postData)
                presentationMode.wrappedValue.dismiss()
            }
            Button("취소", role: .cancel) {}
        }

        //MARK: - 게시글 수정 화면으로 이동
        .fullScreenCover(isPresented: $presentsBoardEditor) {
            BoardEditView(postData: $postData)
        }
        //MARK: - 경고 알림창
        .alert("", isPresented: $warningAlert) {
            Button("Ok") {}
        } message: {
            Text("권한이 없습니다.")
        }
    }
    
}

extension BoardView {
    //MARK: - 댓글 View
    var commentList: some View {
        VStack(alignment: .leading) {
            Divider()
            Text("댓글").font(.system(size: 13)).opacity(0.5)
            Divider()
            //MARK: - 댓글 구성
            VStack(alignment: .leading) {
                ForEach(comments) { comment in
                    VStack() {
                        HStack(alignment: .top) {
                            // 댓글 작성자 프로필 이미지
                            if let url = comment.profileUrl {
                                KFImage(URL(string:url))
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .clipShape(Circle())
                                    .overlay { Circle().stroke(.white, lineWidth: 1) }
                                    .shadow(radius: 1)
                            }
                            // 댓글 작성자 및 내용
                            VStack(alignment: .leading) {
                                Text(comment.author).bold().bold().font(.system(size:15))
                                Text(comment.timestamp.dateValue().toString().components(separatedBy: " ")[0]).opacity(0.5).font(.system(size:12))
                                Text(comment.comment)
                            }
                            
                            Spacer()
                            
                            //댓글 추가메뉴 버튼
                            Button(action: {
                                print("Comment button is clicked")
                                if comment.uid == Auth.auth().currentUser?.uid {
                                    presentsCommentAlert = true
                                    currentComment = comment
                                } else {
                                    warningAlert = true
                                }
                            }, label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(Color.black)
                            })
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .onAppear(perform : {viewModel.getComment(post: postData)})
            .onReceive(viewModel.$comments, perform: { self.comments = $0 })
        }
        //MARK: - 댓글 더보기 메뉴
        .confirmationDialog("", isPresented: $presentsCommentAlert, titleVisibility: .hidden) {
            Button("수정") {
                //TODO: 댓글 수정화면으로 이동
                presentsCommentEditor = true
            }
            Button("삭제", role: .destructive) {
                //TODO: 댓글 삭제 기능 추가
                print("delete Button is Clicked")
                // 댓글 추가메뉴가 클릭되면 currentComment에 할당되기 때문에 강제 언랩핑을 사용함
                viewModel.deleteComment(post: postData, comment: currentComment!)
            }
            Button("취소", role: .cancel) {}
        }
        //MARK: - 게시글 수정 화면으로 이동
        .fullScreenCover(isPresented: $presentsCommentEditor) {
            // 댓글 추가메뉴가 클릭되면 currentComment에 할당되기 때문에 강제 언랩핑을 사용함
            CommentEditView(postData: postData, comment: currentComment!)
        }
    }
}

//struct BoardView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardView()
//    }
//}
