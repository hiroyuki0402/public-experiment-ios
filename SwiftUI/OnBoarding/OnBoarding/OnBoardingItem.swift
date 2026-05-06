//
//  OnBoardingItem.swift
//  OnBoarding
//
//  Created by SHIRAISHI HIROYUKI on 2026/05/07.
//

import SwiftUI

/// オンボーディングの各ページを表すデータモデル
struct OnBoardingItem: Identifiable, Hashable, Sendable {

    /// ページの一意識別子
    let id: Int

    /// ページのタイトルテキスト
    var title: String

    /// ページのサブタイトルテキスト
    var subtitle: String

    /// スクリーンショット画像のリモートURL（nilの場合はfallbackImageを使用）
    var screenshotURL: URL?

    /// URLが取得できない場合に使用するアセットカタログの画像名
    var fallbackImage: String

    /// スクリーンショットのズーム倍率
    var zoomScale: CGFloat = 1

    /// ズーム時のアンカーポイント
    var zoomAnchor: UnitPoint = .center

    /// idベースでハッシュを生成
    /// - Parameter hasher: ハッシュ生成器
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    /// idベースで等価性を判定
    /// - Parameters:
    ///   - lhs: 比較元
    ///   - rhs: 比較先
    /// - Returns: idが一致すればtrue
    static func == (lhs: OnBoardingItem, rhs: OnBoardingItem) -> Bool {
        lhs.id == rhs.id
    }
}
