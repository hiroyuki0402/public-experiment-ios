//
//  SwipeAction.swift
//  WWDC2026
//
//  Created by SHIRAISHI HIROYUKI on 2026/06/10.
//

import SwiftUI

struct SwipeActionView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .swipeActions {
                Text("Hello, world!")
                    .foregroundStyle(.red)
            }
    }
}

#Preview {
    SwipeActionView()
}
