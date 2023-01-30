//
//  ContentView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/28.
//

import SwiftUI

struct ContentView: View {
    
    private var genreList: [String] = [ "Piano","Cello","Violin","Drum"]
    
    var body: some View {
        VStack() {
            // 상단메뉴바
            HStack(alignment: .center, spacing: 20) {
                Text("ART BRIDGE")
                    .fontWeight(.heavy)
                    .font(.system(size: 10))
                SearchView()
                Image(systemName: "person")
                
            } //상단 메뉴
            .padding()

            ScrollView() {
                VStack() {
                    HStack() {
                        Spacer()
                        
                        Button("장르") {
                            print("장르 버튼이 클릭되었습니다.")
                        }.background(.cyan)
                        
                        Spacer()
                        
                        Button("지역") {
                            print("지역 버튼이 클릭되었습니다.")
                        }.background(.cyan)
                        
                        Spacer()
                    }
                    
                    // 장르 선택 ScrollView
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<genreList.count) { i in
                                ImageView(label: genreList[i])
                            }
                        }
                    }//ScrollView
                }.background(.green)
                
                HStack() {
                    Spacer()
                    Text("광고 및 공지사항 표시부분")
                    Spacer()
                }
                .frame(height: 100)
                .background(.brown)
                
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
                }.background(.orange)
            }
        }
        Spacer()
//        .offset(y: -(UIScreen.main.bounds.height * 0.35))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
