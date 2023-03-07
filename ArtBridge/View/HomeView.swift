//
//  ContentView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/28.
//

import SwiftUI

struct HomeView: View {
    @Binding var selection: Int
    
    @State private var isClickedGenre = true
    @State private var isClickedRegion = false
    var genreList: [String] = [ "Piano","Cello","Violin","Drum","Flute","Guitar","Bass"]
    
    var body: some View {
        VStack() {
            ScrollView() {
                VStack() {
                    HStack(spacing:0) {

                        Button(action: {
                            print("장르 버튼이 클릭되었습니다.")
                            self.isClickedGenre.toggle()
                            self.isClickedRegion.toggle()
                        }) {
                            if isClickedGenre {
                                Text("악기")
                                    .foregroundColor(Color.black)
                                    .fontWeight(.heavy)
                            } else {
                                Text("악기")
                                    .foregroundColor(Color.gray)
                                    .fontWeight(.medium)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)

                        Button(action: {
                            print("지역 버튼이 클릭되었습니다.")
                            self.isClickedRegion.toggle()
                            self.isClickedGenre.toggle()
                        }) {
                            if isClickedRegion {
                                Text("지역")
                                    .foregroundColor(Color.black)
                                    .fontWeight(.heavy)
                                
                            } else {
                                Text("지역")
                                    .foregroundColor(Color.gray)
                                    .fontWeight(.medium)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                    }
                    
                    // 장르 선택 ScrollView
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<genreList.count) { i in
                                ImageView(label: genreList[i])
                            }
                        }
                    }//ScrollView
                }
                
                HStack() {
                    Spacer()
//                    Text("광고 및 공지사항 표시부분")
                    Spacer()
                }
//                .frame(height: 50)
//                .background(Color.white)

                VStack() {
                    HStack() {
                        Text("게시글")
                            .fontWeight(.heavy)
                            .font(.system(size:20))
                            .padding()
                        Spacer()
                        Button(action: {
                            print("전체보기 Button is Clicked")
                            selection = 1
                        }, label: {
                            Text("전체보기 >")
                                .font(.system(size:15))
                        })
                        .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 245/255, green: 245/255, blue:245/255))
                    .cornerRadius(12)
                    BoardListView()
                        .frame(width: UIScreen.main.bounds.width, height: 500)
                }//VStack()
                
                }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(selection: <#Binding<Int>#>)
//    }
//}
