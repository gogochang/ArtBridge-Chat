//
//  PeopleView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/16.
//

import SwiftUI
import Firebase

struct PeopleView: View {
    @Binding var selection: Int
    @State var users : [firesotreUsers] = []
    @State private var showingAlert = false
    
    var body: some View {
        List(users) { aUser in
            Button(action: {
                print("People Button is Clicked")
                print("uid -> \(aUser.id)")
                showingAlert = true
            }, label: {
                HStack() {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                    VStack(alignment: .leading) {
                        Text("\(aUser.username)").font(.system(size: 15))
                        Text("\(aUser.email)").font(.system(size: 13))
                    }
                }
            })
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("채팅"),
                    message: Text("\(aUser.username)에게 메세지를 보내시겠습니까?"),
                    primaryButton: .destructive(Text("No"), action: {}),
                    secondaryButton: .default(Text("Yes"), action: {
                        FirebaseService.createChatRoom(destinationUserUid: aUser.id) {
                            selection = 3
                        }
                        
                    })
                )
            }
        }
        .listStyle(PlainListStyle())
        .onAppear(perform: {
            print("PeopleView - onAppear() called ")
            FirebaseService.getAllUsers(completion: { roadInfos in
                print(roadInfos)
                self.users = roadInfos
            })
        })
                  
    }
}

//struct PeopleView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeopleView()
//    }
//}
