//
//  ContentView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/28.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack() {
            HStack(alignment: .center, spacing: 10) {
                Text("ART BRIDGE")
                    .fontWeight(.heavy)
                    .font(.system(size: 10))
                    .foregroundColor(Color.orange)
                SearchView()
                Image(systemName: "bell")
                Image(systemName: "person")
                
            } //상단 메뉴
            .padding()
            
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("홈")
                    }
                
                PostsView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("게시판")
                    }
                
                PeopleView()
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("사람")
                    }
                
                MessageView()
                    .tabItem {
                        Image(systemName: "message")
                        Text("채팅")
                    }
                
                MyPageView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("마이페이지")
                    }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
