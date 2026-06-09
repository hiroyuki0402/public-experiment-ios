//
//  HomeViewModel.swift
//  SideBar
//
//  Created by SHIRAISHI HIROYUKI on 2026/06/07.
//

import Observation
import SwiftUI

/// ホーム画面の状態を管理する ViewModel
@Observable
final class HomeViewModel {
    /// 現在選択中のタブインデックス
    var activeTab: Int = 0

    /// ナビゲーション遷移を管理するパス
    var navigationPath: NavigationPath = .init()

    /// サイドメニューの展開状態
    var isExpanded: Bool = false

    /// ナビゲーション遷移中はサイドメニューのジェスチャーを無効化する
    var isMenuEnabled: Bool {
        navigationPath.isEmpty
    }
}
