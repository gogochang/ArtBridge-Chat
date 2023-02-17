//
//  PeopleView.swift
//  ArtBridge
//
//  Created by 김창규 on 2023/02/16.
//

import SwiftUI

struct PeopleView: View {
    
    var body: some View {
        List {
            Text("A 사람")
            Text("B 사람")
            Text("C 사람")
            Text("D 사람")
        }
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
    }
}
