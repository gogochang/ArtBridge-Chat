//
//  ProfileVM.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/03/20.
//

import Foundation
import FirebaseAuth

class ProfileVM: ObservableObject {
    let userService = UserService()
    
    //프로필 표시 할 유저 정보
    @Published var userProfile: User?
    
    //프로필 표시 할 UID
    @Published var uid: String?
    
    // 유저 정보를 가져와서 userProfile에 저장
    func fetchUser() {
        print("UserVM - fetchUser() called")
        guard let uid = uid else{ return }
        userService.fetchUser(uid: uid) { user in
            self.userProfile = user
        }
    }
}
