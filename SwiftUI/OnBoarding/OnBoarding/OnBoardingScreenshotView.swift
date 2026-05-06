//
//  OnBoardingScreenshotView.swift
//  OnBoarding
//
//  Created by SHIRAISHI HIROYUKI on 2026/05/07.
//

import SwiftUI

/// デバイスフレーム風のベゼル付きでスクリーンショットをページング表示するView
struct OnBoardingScreenshotView: View {

    /// 表示するオンボーディングアイテム
    let items: [OnBoardingItem]

    /// 現在表示中のページインデックス
    let currentIndex: Int

    /// ベゼル（端末フレーム）を非表示にするかどうか
    let hideBezels: Bool

    /// スクリーンショットの実際の描画サイズ
    @Binding var screenshotSize: CGSize

    // MARK: - Constants

    private enum Metrics {
        /// スクリーンショット間の水平方向スペース
        static let itemSpacing: CGFloat = 12
        /// 実デバイスの角丸を再現するための基準値
        static let deviceCornerRadiusBase: CGFloat = 180
        /// ベゼル外枠の線幅
        static let bezelOuterLineWidth: CGFloat = 6
        /// ベゼル内枠の線幅
        static let bezelInnerLineWidth: CGFloat = 4
        /// ベゼル最内枠の線幅
        static let bezelInnermostLineWidth: CGFloat = 6
        /// ベゼル最内枠の内側パディング
        static let bezelInnermostPadding: CGFloat = 4
        /// ベゼルオーバーレイ全体のネガティブパディング
        static let bezelOverlayPadding: CGFloat = -7
    }

    /// デバイス画面風の角丸形状
    private let shape = ConcentricRectangle(corners: .concentric, isUniform: true)

    /// スクリーンショットサイズと画像の実サイズ比率から算出したデバイス角丸
    private var deviceCornerRadius: CGFloat {
        guard let first = items.first,
              let image = UIImage(named: first.fallbackImage) else { return 0 }
        let ratio = screenshotSize.height / image.size.height
        return Metrics.deviceCornerRadiusBase * ratio
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            /// スクリーンショット未読み込み時の背景
            Rectangle()
                .fill(.black)

            /// 水平スクロールによるページング表示
            ScrollView(.horizontal) {
                HStack(spacing: Metrics.itemSpacing) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        ScreenshotImageView(item: item)
                            .onGeometryChange(for: CGSize.self) { $0.size } action: { newValue in
                                guard index == 0, screenshotSize == .zero else { return }
                                screenshotSize = newValue
                            }
                            .clipShape(shape)
                            .frame(width: size.width, height: size.height)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollDisabled(true)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollPosition(id: .init(get: { currentIndex }, set: { _ in }))
        }
        .clipShape(shape)
        .overlay { bezelOverlay }
        .frame(
            maxWidth: screenshotSize.width == 0 ? nil : screenshotSize.width,
            maxHeight: screenshotSize.height == 0 ? nil : screenshotSize.height
        )
        .containerShape(RoundedRectangle(cornerRadius: deviceCornerRadius))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Private Views

    /// デバイスフレームを模したベゼルオーバーレイ
    @ViewBuilder
    private var bezelOverlay: some View {
        if screenshotSize != .zero && !hideBezels {
            ZStack {
                shape.stroke(.white, lineWidth: Metrics.bezelOuterLineWidth)
                shape.stroke(.black, lineWidth: Metrics.bezelInnerLineWidth)
                shape.stroke(.black, lineWidth: Metrics.bezelInnermostLineWidth)
                    .padding(Metrics.bezelInnermostPadding)
            }
            .padding(Metrics.bezelOverlayPadding)
        }
    }
}
