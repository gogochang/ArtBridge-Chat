//
//  PostView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/01.
//

import SwiftUI

struct BoardView: View {
    
    @ObservedObject var viewModel = PostVM()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var commentText: String = ""
    @State private var presentsAlert: Bool = false
    @State private var presentsBoardEditor: Bool = false
    @State var postData: Post
    
    @State var comments = [Comment]()
    var body: some View {
        NavigationView {
            ScrollView() {
                VStack(alignment: .leading) {
                    // 제목
                    Text(postData.title)
                        .font(.title3)
                        .bold()
                        .padding([.bottom], 5)
                    
                    // 글 작성자, 날짜
                    HStack() {
//                        Image(systemName: "person.fill")
                        AsyncImage(
                            url: URL(string:postData.profileUrl),
                            content: { image in
                                image
                                    .resizable()
                                    .frame(maxWidth: 50, maxHeight: 50)
                                    .cornerRadius(12)
                            },
                            placeholder: {
                                
                            }
                        )
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
                        .padding([.bottom], 20)
                    
                    Text(postData.content)
                    if let url = postData.imageUrl {
                        AsyncImage(
                            url: URL(string:url),
                            content: { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(12)
                            },
                            placeholder: {

                            }
                        )
                    }
                    Divider()
                    Text("댓글").bold()
                    Divider()
                    Group {
                        VStack(alignment: .leading) {
                            ForEach(comments) { comment in
                                VStack() {
                                    HStack(alignment: .top) {
                                        if let url = comment.profileUrl {
                                            AsyncImage(
                                                url: URL(string:url),
                                                content: { image in
                                                    image
                                                        .resizable()
                                                        .frame(width: 25, height: 25)
                                                        .cornerRadius(12)
                                                },
                                                placeholder: {

                                                }
                                            )
                                        }
//                                        Image(systemName: "person.circle")
//                                            .resizable()
//                                            .frame(width: 25, height: 25)
//
                                        VStack(alignment: .leading) {
                                            Text(comment.author).bold()
                                            Text(comment.timestamp.dateValue().toString().components(separatedBy: " ")[0]).opacity(0.5).font(.system(size:12))
                                            Text(comment.comment)
                                                .padding([.top], 2)
                                        }
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .onAppear(perform : {viewModel.getComment(post: postData)})
                        .onReceive(viewModel.$comments, perform: { self.comments = $0 })
                        
                        HStack() {
                            TextField("댓글 작성하기", text: $commentText).background()
                            Button(action: {
                                print("SendButton is Clicked")
                                viewModel.addComment(post: postData, comment: commentText)
                                self.commentText = ""
                            }, label: {
                                Text("Send")
                            })
                        }
                    }
                }//VStack
                .padding()
                Spacer()
            }//HStack
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
                presentsAlert = true
        }, label: {
            Image(systemName: "ellipsis")
                .foregroundColor(Color.black)
        }))
        
        // 더보기 메뉴
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
        .fullScreenCover(isPresented: $presentsBoardEditor) {
            BoardEditView(postData: $postData)
        }

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
