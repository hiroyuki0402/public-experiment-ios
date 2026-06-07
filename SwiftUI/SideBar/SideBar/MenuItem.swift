//
//  MenuItem.swift
//  SideBar
//
//  Created by SHIRAISHI HIROYUKI on 2026/06/01.
//

import DeveloperToolsSupport
import SwiftUI

struct MenuItem: Hashable {
    let title: String
    var iconURL: String? = nil
    var iconSystemName: String? = nil
    var defaultIcon: ImageResource? = nil
    let destination: String
}

// TODO: 削除
// MARK: - テストデータ

func makeSampleMenuItems() -> [MenuItem] {
    [
        .init(title: "動画", iconSystemName: "video", destination: "Video"),
        .init(title: "ブックマーク", iconSystemName: "bookmark", destination: "Bookmarks"),
        .init(title: "コミュニティ", iconSystemName: "person.2", destination: "Communities"),
        .init(title: "メッセージ", iconSystemName: "bubble", destination: "Messages"),
        .init(title: "リスト", iconSystemName: "list.clipboard", destination: "Lists"),
        .init(title: "スペース", iconSystemName: "mic", destination: "Spaces"),
    ]
}
