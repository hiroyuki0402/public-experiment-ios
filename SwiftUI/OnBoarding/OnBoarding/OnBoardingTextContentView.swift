//
//  OnBoardingTextContentView.swift
//  OnBoarding
//
//  Created by SHIRAISHI HIROYUKI on 2026/05/07.
//

import SwiftUI

/// オンボーディングのタイトル・サブタイトルをページング表示するView
struct OnBoardingTextContentView: View {

    /// 表示するオンボーディングアイテムの配列
    let items: [OnBoardingItem]

    /// 現在表示中のページインデックス
    let currentIndex: Int

    // MARK: - Constants

    private enum Metrics {
        /// タイトルとサ��タイトルの間隔
        static let textSpacing: CGFloat = 6
        /// 非アクティブページのブラー半径
        static let inactiveBlurRadius: CGFloat = 30
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            /// ページングスクロールでテキストを切り替え
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        let isActive = currentIndex == index

                        /// タイトル・サブタイトルの縦積み
                        VStack(spacing: Metrics.textSpacing) {
                            Text(item.title)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .foregroundStyle(.white)

                            Text(item.subtitle)
                                .font(.callout)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .frame(width: size.width)
                        .compositingGroup()
                        .blur(radius: isActive ? 0 : Metrics.inactiveBlurRadius)
                        .opacity(isActive ? 1 : 0)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollDisabled(true)
            .scrollTargetBehavior(.paging)
            .scrollClipDisabled()
            .scrollPosition(id: .init(get: { currentIndex }, set: { _ in }))
        }
    }
}
