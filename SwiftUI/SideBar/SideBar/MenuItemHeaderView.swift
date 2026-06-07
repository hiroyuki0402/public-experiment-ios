//
//  MenuItemHeaderView.swift
//  SideBar
//
//  Created by SHIRAISHI HIROYUKI on 2026/06/01.
//

import SwiftUI

struct MenuItemHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Circle()
                    .fill(.fill)
                    .frame(width: 60, height: 60)
                    .padding(.bottom, 10)
            }

            Text("山田太郎")
                .font(.title3)
                .fontWeight(.semibold)

            Text("@test")
                .foregroundStyle(.gray)

            HStack(spacing: 2) {
                Text("3K")
                    .fontWeight(.bold)

                Text("フォロー中")
                    .foregroundStyle(.primary.opacity(0.7))

                Text("1.7M")
                    .fontWeight(.bold)
                    .padding(.leading, 10)

                Text("フォロワー")
                    .foregroundStyle(.primary.opacity(0.7))
            }
            .font(.callout)
            .fontWeight(.medium)
            .padding(.top, 5)
        }
    }
}

#Preview {
    MenuItemHeaderView()
}
