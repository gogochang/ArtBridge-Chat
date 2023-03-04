//
//  ArtBridgeApp.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/28.
//

import SwiftUI
import FirebaseCore
import Firebase
import KakaoSDKCommon
import KakaoSDKAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ArtBridgeApp: App {
    
    //register app delegate for Firebase Setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Kakao SDK 초기화
    init() {
        KakaoSDK.initSDK(appKey: "50bada366610004a2feb7c93229ebb55")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserVM())
                .environmentObject(PostVM())
                .onOpenURL{ url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
