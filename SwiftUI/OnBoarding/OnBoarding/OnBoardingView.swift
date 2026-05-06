//
//  OnBoardingView.swift
//  OnBoarding
//
//  Created by SHIRAISHI HIROYUKI on 2026/05/07.
//

import SwiftUI

/// オンボーディング画面のルートView
///
/// スクリーンショット・テキスト・インジケーター・ナビゲーションボタンを
/// 組み合わせたフルスクリーンのオンボーディング体験を提供する。
struct OnBoardingView: View {

    /// 表示するオンボーディングページの配列
    let items: [OnBoardingItem]

    /// ボタンやアクセントに使用するカラー
    var tint: Color = .blue

    /// デバイスフレームのベゼルを非表示にするか
    var hideBezels: Bool = false

    /// ページ遷移アニメーション
    var animation: Animation = .interpolatingSpring(duration: 0.65, bounce: 0, initialVelocity: 0)

    /// 最終ページで「Get Started」タップ時に呼ばれるコールバック
    var onComplete: @Sendable () -> Void

    /// 現在表示中のページインデックス
    @State private var currentIndex: Int = 0

    /// スクリーンショットサイズ
    @State private var screenshotSize: CGSize = .zero

    // MARK: - Constants

    private enum Metrics {
        /// スクリーンショット領域の上パディング
        static let screenshotTopPadding: CGFloat = 35
        /// スクリーンショット領域の水平パディング
        static let screenshotHorizontalPadding: CGFloat = 30
        /// スクリーンショット領域の下パディング（テキスト領域分の余白）
        static let screenshotBottomPadding: CGFloat = 220
        /// テキストキスト領域内の要素間隔
        static let contentSpacing: CGFloat = 10
        /// テキスト領域の上パディング
        static let contentTopPadding: CGFloat = 20
        /// テキスト領域の水平パディング
        static let contentHorizontalPadding: CGFloat = 15
        /// テキスト領域の��定高さ
        static let contentHeight: CGFloat = 210
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            /// デバイスフレーム付きスクリーンショット
            OnBoardingScreenshotView(
                items: items,
                currentIndex: currentIndex,
                hideBezels: hideBezels,
                screenshotSize: $screenshotSize
            )
            .compositingGroup()
            .scaleEffect(
                items[currentIndex].zoomScale,
                anchor: items[currentIndex].zoomAnchor
            )
            .padding(.top, Metrics.screenshotTopPadding)
            .padding(.horizontal, Metrics.screenshotHorizontalPadding)
            .padding(.bottom, Metrics.screenshotBottomPadding)

            /// テキスト・インジケーター・ボタン領域
            VStack(spacing: Metrics.contentSpacing) {
                OnBoardingTextContentView(items: items, currentIndex: currentIndex)
                OnBoardingIndicatorView(items: items, currentIndex: currentIndex)
                OnBoardingContinueButton(
                    currentIndex: currentIndex,
                    itemCount: items.count,
                    tint: tint
                ) {
                    if currentIndex == items.count - 1 {
                        onComplete()
                    }
                    withAnimation(animation) {
                        currentIndex = min(currentIndex + 1, items.count - 1)
                    }
                }
            }
            .padding(.top, Metrics.contentTopPadding)
            .padding(.horizontal, Metrics.contentHorizontalPadding)
            .frame(height: Metrics.contentHeight)
            .background {
                /// ズーム時のみ表示されるガラスブラー
                OnBoardingGlassBlurView(zoomScale: items[currentIndex].zoomScale)
            }

            /// 左上の戻るボタン
            OnBoardingBackButton {
                withAnimation(animation) {
                    currentIndex = max(currentIndex - 1, 0)
                }
            }
        }
        .background(.black)
    }
}

// MARK: - Preview

#Preview {
    OnBoardingView(items: [
        .init(id: 0, title: "Welcome to iOS 26", subtitle: "Introducing a new design with\nLiquid Glass.", fallbackImage: "0"),
        .init(id: 1, title: "Control Center", subtitle: "Redesigned for quick access.", fallbackImage: "1"),
        .init(id: 2, title: "Notifications", subtitle: "Cleaner, more visual.", fallbackImage: "2"),
        .init(id: 3, title: "Lock Screen", subtitle: "More customizable than ever.", fallbackImage: "3"),
        .init(id: 4, title: "Messages", subtitle: "New effects and reactions.", fallbackImage: "4"),
        .init(id: 5, title: "Photos", subtitle: "AI-powered memories.", fallbackImage: "5"),
        .init(id: 6, title: "Get Started", subtitle: "Enjoy iOS 26.", fallbackImage: "6"),
    ]) {
        print("completed")
    }
}
