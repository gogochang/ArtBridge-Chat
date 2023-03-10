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
        VStack {
            Image(label)
                .resizable()
                .frame(width:75, height: 75)
                .cornerRadius(12)
            Text(label)
                .opacity(0.7)
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(label: "Piano")
    }
}
