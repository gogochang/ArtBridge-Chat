//
//  FaceBookLoginView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/07.
//

import SwiftUI

struct FaceBookLoginView: View {
    var body: some View {
        Button(action: {
            print("LoginView - Clicked FaceBook Button")
        }, label: {
            HStack() {
                Spacer()
                Text("페이스북으로 시작")
                Spacer()
            }
            .frame(height: 10)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color(.systemBlue))
            .cornerRadius(10)
        })
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

struct FaceBookLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FaceBookLoginView()
    }
}
