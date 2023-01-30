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
            Image(systemName: "lock")
                .foregroundColor(.secondary)
            TextField("Search", text: $text)
//                .frame(width: UIScreen.main.bounds.width - 150, height: 3)
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(5)
        }
        .padding()
        .frame(height: 30)
        .background(Capsule().fill(.gray))
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
