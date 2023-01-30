//
//  ImageView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/30.
//

import SwiftUI

struct ImageView: View {
    @State var label: String
    
    var body: some View {
        ZStack {
            Image(label)
                .resizable()
                .frame(width:100, height: 100)
                .cornerRadius(15)
                .shadow(radius: 5)
            Text(label)
                .font(.system(size:25, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 5)
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(label: "Piano")
    }
}
