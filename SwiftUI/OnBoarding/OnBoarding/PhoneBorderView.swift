//
//  PhoneBorderView.swift
//  OnBoarding
//
//  Created by SHIRAISHI HIROYUKI on 2026/05/07.
//

import SwiftUI

/// デバイスのベゼルフレームを描画する汎用View
struct PhoneBorderView: View {

    /// ベゼルの形状（ConcentricRectangleを想定）
    let shape: ConcentricRectangle

    /// スクリーンショットの描画サイズ
    @State private var screenshotSize: CGSize = .zero

    // MARK: - Constants

    private enum Metrics {
        /// 外枠の線幅
        static let outerLineWidth: CGFloat = 6
        /// 内枠の線幅
        static let innerLineWidth: CGFloat = 4
        /// 最内枠の線幅
        static let innermostLineWidth: CGFloat = 6
        /// 最内枠の内側パディング
        static let innermostPadding: CGFloat = 4
        /// containerShape���角丸
        static let containerCornerRadius: CGFloat = 20
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            shape
                .stroke(.white, lineWidth: Metrics.outerLineWidth)

            shape
                .stroke(.black, lineWidth: Metrics.innerLineWidth)

            shape
                .stroke(.black, lineWidth: Metrics.innermostLineWidth)
                .padding(Metrics.innermostPadding)
        }
        .frame(
            maxWidth: screenshotSize.width == 0 ? nil : screenshotSize.width,
            maxHeight: screenshotSize.height == 0 ? nil : screenshotSize.height
        )
        .containerShape(RoundedRectangle(cornerRadius: Metrics.containerCornerRadius))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PhoneBorderView(shape: ConcentricRectangle(corners: .concentric, isUniform: true))
        .padding()
        .background(.black)
}
