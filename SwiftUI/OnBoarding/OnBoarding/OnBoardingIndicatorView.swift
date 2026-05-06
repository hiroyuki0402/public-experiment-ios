//
//  OnBoardingIndicatorView.swift
//  OnBoarding
//
//  Created by SHIRAISHI HIROYUKI on 2026/05/07.
//

import SwiftUI

/// ページインジケーター（現在位置を示すドット）
struct OnBoardingIndicatorView: View {

    /// 表示するオンボーディングアイテムの配列
    let items: [OnBoardingItem]

    /// 現在表示中のページインデックス
    let currentIndex: Int

    // MARK: - Constants

    private enum Metrics {
        /// ドット間の間隔
        static let spacing: CGFloat = 6
        /// アクティブドットの幅
        static let activeWidth: CGFloat = 25
        /// 非アクティブドットの幅
        static let inactiveWidth: CGFloat = 6
        /// ドットの高さ
        static let height: CGFloat = 6
        /// 下パディング
        static let bottomPadding: CGFloat = 5
    }

    // MARK: - Body

    var body: some View {
        HStack(spacing: Metrics.spacing) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, _ in
                let isActive = currentIndex == index
                Capsule()
                    .fill(.white.opacity(isActive ? 1 : 0.4))
                    .frame(
                        width: isActive ? Metrics.activeWidth : Metrics.inactiveWidth,
                        height: Metrics.height
                    )
            }
        }
        .padding(.bottom, Metrics.bottomPadding)
    }
}
