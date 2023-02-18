//
//  PeopleView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/16.
//

import SwiftUI
import Firebase

struct PeopleView: View {
    
    @State var users : [firesotreUsers] = []
    
    var body: some View {
        List(users) { aUser in
            Text("\(aUser.email)")
        }
        .onAppear(perform: {
            print("PeopleView - onAppear() called ")
            FirebaseService.getAllUsers(completion: { roadInfos in
                print(roadInfos)
                self.users = roadInfos
            })
        })
                  
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
    }
}
