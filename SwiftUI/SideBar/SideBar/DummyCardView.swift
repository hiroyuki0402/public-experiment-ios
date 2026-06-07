//
//  File.swift
//  SideBar
//
//  Created by SHIRAISHI HIROYUKI on 2026/06/01.
//

import SwiftUI

/// SNS風のプレースホルダーカードビュー
struct DummyCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                Circle()
                    .fill(.fill)
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 5) {
                    Rectangle()
                        .fill(.fill)
                        .frame(width: 120, height: 15)

                    Rectangle()
                        .fill(.fill)
                        .frame(height: 15)
                }
            }

            Rectangle()
                .foregroundStyle(.fill)
                .frame(height: 250)
                .padding(.leading, 50)

            HStack(spacing: 0) {
                Group {
                    Image(systemName: "bubble")
                    Image(systemName: "arrow.2.squarepath")
                    Image(systemName: "suit.heart")
                    Image(systemName: "bookmark")
                    Image(systemName: "square.and.arrow.up")
                }
                .foregroundStyle(.fill)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 50)
        }
    }
}
