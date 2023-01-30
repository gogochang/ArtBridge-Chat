//
//  ContentView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/28.
//

import SwiftUI

struct HomeView: View {
    @State private var isClickedGenre = true
    @State private var isClickedRegion = false
    private var genreList: [String] = [ "Piano","Cello","Violin","Drum"]
    
    var body: some View {
        VStack() {
            // 상단메뉴바
            HStack(alignment: .center, spacing: 10) {
                Text("ART BRIDGE")
                    .fontWeight(.heavy)
                    .font(.system(size: 10))
//                    .foregroundColor(.brown)
                SearchView()
                Image(systemName: "bell")
                Image(systemName: "person")
                
            } //상단 메뉴
            .padding()

            ScrollView() {
                VStack() {
                    HStack(spacing:0) {

                        Button(action: {
                            print("장르 버튼이 클릭되었습니다.")
                            self.isClickedGenre.toggle()
                            self.isClickedRegion.toggle()
                        }) {
                            if isClickedGenre {
                                Text("장르")
                                    .foregroundColor(Color.black)
                                    .fontWeight(.heavy)
                            } else {
                                Text("장르")
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
                    Text("광고 및 공지사항 표시부분")
                    Spacer()
                }
                .frame(height: 100)
//                .background(.brown)
                
                VStack() {
                    HStack() {
                        Text("인기글")
                            .fontWeight(.heavy)
                            .font(.system(size:20))
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                        Spacer()
                    }
                    PrevPostsView()
                    PrevPostsView()
                    PrevPostsView()
                    PrevPostsView()
                }
                
                }
        }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
