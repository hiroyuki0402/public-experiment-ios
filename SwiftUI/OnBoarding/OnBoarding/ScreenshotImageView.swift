//
//  ScreenshotImageView.swift
//  OnBoarding
//
//  Created by SHIRAISHI HIROYUKI on 2026/05/07.
//

import SwiftUI

/// スクリーンショット画像を表示するView
struct ScreenshotImageView: View {

    /// 表示対象のオンボーディングアイテム
    let item: OnBoardingItem

    // MARK: - Body

    var body: some View {
        if let url = item.screenshotURL {
            remoteImageView(url: url)
        } else {
            fallbackView
        }
    }

    // MARK: - Private Views

    /// URLから非同期で画像を読み込むView
    private func remoteImageView(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure:
                fallbackView
            default:
                ProgressView()
            }
        }
    }

    /// URL読み込み失敗時またはURL未指定時のフォールバック表示
    private var fallbackView: some View {
        Image(item.fallbackImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
