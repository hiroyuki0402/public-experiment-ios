//
//  OnBoardingContinueButton.swift
//  OnBoarding
//
//  Created by SHIRAISHI HIROYUKI on 2026/05/07.
//

import SwiftUI

/// 次ページへ進む / オンボーディング完了ボタン
///
/// 最終ページでは「Get Started」、それ以外では「Continue」を表示する。
struct OnBoardingContinueButton: View {

    /// 現在表示中のページインデックス
    let currentIndex: Int

    /// アイテム総数
    let itemCount: Int

    /// ボタンのアクセントカラー
    var tint: Color = .blue

    /// タップ時に呼ばれるアクション
    let action: () -> Void

    // MARK: - Constants

    private enum Metrics {
        /// ボタンテキストの垂直パディング
        static let verticalPadding: CGFloat = 6
        /// ボタンの水平パディング
        static let horizontalPadding: CGFloat = 30
    }

    // MARK: - Private

    /// 最終ページかどうか
    private var isLastPage: Bool {
        currentIndex == itemCount - 1
    }

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            Text(isLastPage ? "はじめよう" : "つぎへ")
                .fontWeight(.medium)
                .contentTransition(.numericText())
                .padding(.vertical, Metrics.verticalPadding)
        }
        .tint(tint)
        .buttonStyle(.glassProminent)
        .buttonSizing(.flexible)
        .padding(.horizontal, Metrics.horizontalPadding)
    }
}
