//
//  AppleLoginView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/07.
//

import SwiftUI

struct AppleLoginView: View {
    var body: some View {
        Button(action: {
            print("LoginView - Clicked Apple Button")
        }, label: {
            HStack() {
                Spacer()
                Text("Apple로 시작")
                Spacer()
            }
            .frame(height: 10)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.black)
            .cornerRadius(10)
        })
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        .shadow(radius: 5)
    }
}

struct AppleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginView()
    }
}
