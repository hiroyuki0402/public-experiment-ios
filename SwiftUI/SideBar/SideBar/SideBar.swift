//
//  SideBar.swift
//  SideBar
//
//  Created by SHIRAISHI HIROYUKI on 2026/06/01.
//

import SwiftUI

/// サイドバーの中身
/// ユーザープロフィール情報とナビゲーションメニュー項目を表示する
struct SideBar: View {
    @Binding var isExpanded: Bool
    @Binding var path: NavigationPath
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            MenuItemHeaderView()

            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 30) {
                    ForEach(makeSampleMenuItems(), id: \.self) { item in
                        MenuItemMainView(item: .init(title: item.title,
                                                 iconSystemName: item.iconSystemName,
                                                 destination: item.destination)) { item in

                        }

                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
            }
            .mask {
                Rectangle()
                    .ignoresSafeArea()
            }
            .overlay(alignment: .top) {
                Divider()
                    .background(.white.tertiary)
                    .padding(.horizontal, -15)
            }
            .padding(.top, 15)
            .scrollClipDisabled()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.horizontal, .top], 15)
    }
}