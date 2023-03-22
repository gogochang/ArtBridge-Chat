//
//  ContentView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/28.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    var body: some View {
        NavigationView {
            VStack() {
                TabView(selection: $selection) {
                    BoardListView()
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("게시판")
                        }.tag(0)
                    
//                    PeopleView(selection: $selection)
//                    Text("UserListView")
//                        .tabItem {
//                            Image(systemName: "person.2")
//                            Text("사람")
//                        }.tag(2)
                    
                    ChatListView()
                        .tabItem {
                            Image(systemName: "message")
                            Text("채팅")
                        }.tag(3)
                    
                    MyPageView()
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("마이페이지")
                        }.tag(4)
                }//TabView
            }//VStack
        }//NavigationView
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
