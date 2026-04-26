//
//  TabItem.swift
//  GlassTabBar
//
//  Created by SHIRAISHI HIROYUKI on 2026/04/23.
//

import SwiftUI

/// タブバーに表示する各タブの定義
enum TabItems: String, CaseIterable {
    /// ホームタブ
    case home = "Home"
    /// 通知タブ
    case notifications = "Notifications"
    /// 設定タブ
    case settings = "Settings"

    /// タブバーに表示するSF Symbolsのアイコン名
    var symbol: String {
        switch self {
        case .home:
            return "house"
        case .notifications:
            return "bell"
        case .settings:
            return "gearshape"
        }
    }

    /// タブ選択時に表示するアクション用のSF Symbolsアイコン名
    var actionSymbol: String {
        switch self {
        case .home:
            return "plus"
        case .notifications:
            return "tray.full.fill"
        case .settings:
            return "cloud.moon.fill"
        }
    }

    /// タブの表示名
    var title: String {
        rawValue
    }

    /// タブバー用のSF Symbolsアイコン名（symbolと同じ）
    var icon: String {
        symbol
    }

    /// 各タブのコンテンツView
    @ViewBuilder
    var content: some View {
        switch self {
        case .home:
            Text("Home")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.red.opacity(0.5))
        case .notifications:
            Text("Notification")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.blue.opacity(0.5))
        case .settings:
            Text("Settings")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.green.opacity(0.5))
        }
    }

    /// allCases内でのインデックス
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}


#Preview {
    ContentView()
}
