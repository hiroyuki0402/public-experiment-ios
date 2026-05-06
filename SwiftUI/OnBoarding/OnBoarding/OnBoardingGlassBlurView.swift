//
//  OnBoardingGlassBlurView.swift
//  OnBoarding
//
//  Created by SHIRAISHI HIROYUKI on 2026/05/07.
//

import SwiftUI

/// ズームされたスクリーンショットの下部にかかるガラスブラー背景
struct OnBoardingGlassBlurView: View {

    /// 現在のズーム倍率（1より大きい場合にブラーを表示）
    let zoomScale: CGFloat

    // MARK: - Constants

    private enum Metrics {
        /// ブラーの半径
        static let blurRadius: CGFloat = 15
        /// 背景色の透明度
        static let backgroundOpacity: CGFloat = 0.5
    }

    // MARK: - Body

    var body: some View {
        Rectangle()
            .fill(.black.opacity(Metrics.backgroundOpacity))
            .glassEffect(.clear, in: .rect)
            .blur(radius: Metrics.blurRadius)
            .padding([.horizontal, .bottom], -Metrics.blurRadius * 2)
            .padding(.top, -Metrics.blurRadius / 2)
            .opacity(zoomScale > 1 ? 1 : 0)
            .ignoresSafeArea()
    }
}
