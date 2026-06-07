//
//  MenuItemView.swift
//  SideBar
//
//  Created by SHIRAISHI HIROYUKI on 2026/06/01.
//

import SwiftUI

struct MenuItemMainView: View {
    /// メニューのアイテム
    var item: MenuItem

    /// アイコン関連
    var systemIconFont: Font = .body
    var systemIconSize: CGFloat = 18
    var systemIconColor: Color = Color(uiColor: .systemGray2)
    var systemIconFrameWidth: CGFloat = 20
    var systemIconFrameHeight: CGFloat = 20
    var systemIconedges: Edge.Set = .trailing
    var systemIconPadding: CGFloat? = 10
    var contentMode: ContentMode = .fit

    /// フォント関連
    var font: Font = .body
    var fontSize: CGFloat = 18
    var fontColor: Color = Color(uiColor: .darkGray)

    /// ボタン関連
    var buttonEdges: Edge.Set = .horizontal
    var buttonPadding: CGFloat? = 10
    var didSelect: (MenuItem) -> Void

    // MARK: - ボディー

    var body: some View {
        Button {

        } label: {
            HStack {
                imageView()
                Text(item.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(fontColor)
                    .font(font)
            }
        }
        .padding(buttonEdges, buttonPadding)
        .buttonStyle(.borderless)
    }

    // MARK: - Method

    @ViewBuilder
    func imageView() -> some View {

        if let imageName = item.iconURL {
            // TODO: - Kingfisherの変更
            AsyncImage(url: .init(string: imageName))

        } else if let imageName = item.iconSystemName {

            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .frame(width: systemIconFrameWidth,
                       height: systemIconFrameHeight)
                .foregroundStyle(systemIconColor)
                .font(systemIconFont)
                .padding(systemIconedges, systemIconPadding)

        }
    }
}

// MARK: プレビュー

#Preview {
    MenuItemMainView(item: .init(title: "テスト",
                             iconSystemName: "house",
                             destination: "")) { _ in
    }
}
