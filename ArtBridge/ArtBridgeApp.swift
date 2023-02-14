//
//  ArtBridgeApp.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/28.
//

import SwiftUI

@main
struct ArtBridgeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserVM())
                .environmentObject(PostVM())
                
        }
    }
}
