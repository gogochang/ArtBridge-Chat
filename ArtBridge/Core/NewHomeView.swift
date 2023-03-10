//
//  NewHomeView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/09.
//

import SwiftUI

struct NewHomeView: View {
    let data = Array(1...8).map {"피아노 \($0)"}
    let columns = [GridItem(.adaptive(minimum: 70))]
    let genreList: [String] = [ "피아노","첼로","바이올린","드럼","플루트","기타","베이스"]
    
    @Binding var selection: Int
    
    var body: some View {
        VStack() {
            Text("ART BRIDGE")
                .fontWeight(.heavy)
                .font(.system(size: 20))
                .shadow(radius: 5)
                .foregroundColor(Color.orange)
            
            ScrollView() {
                VStack(alignment: .leading) {
//                    SearchView()
//                        .padding()
                    Text("악기별로 보기")
                        .fontWeight(.heavy)
                        .padding()
                    LazyVGrid(columns: columns, alignment: .center, spacing: 30) {
                        ForEach(0..<genreList.count) { i in
                            VStack {
                                ImageView(label: genreList[i])
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Text("지역별로 보기")
                        .fontWeight(.heavy)
                        .padding()
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(data, id: \.self) { i in
                            VStack() {
                                ImageView(label: genreList[0])
                            }
                        }
                    }
                    
                    Rectangle().fill(Color.gray.opacity(0.1)).frame(height:20)
                    
                    HStack() {
                        Text("게시글 보기")
                            .fontWeight(.heavy)
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
                    BoardListView()
                        .frame(width: UIScreen.main.bounds.width, height: 300)
                    Spacer()
                }
            }
        }
    }
}

//struct NewHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewHomeView()
//    }
//}
