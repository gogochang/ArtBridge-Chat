//
//  Search.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/01/30.
//

import SwiftUI

struct SearchView: View {
    @State private var text: String = ""
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.orange)
            TextField("Search", text: $text)
                
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .overlay(RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color("black"), lineWidth: 2)
//                      )
        }
        .padding()
        .frame(height: 60)
        .overlay {
            Capsule().stroke(.black, lineWidth: 2)
        }
//        .background(Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255))
//        .cornerRadius(10)
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
