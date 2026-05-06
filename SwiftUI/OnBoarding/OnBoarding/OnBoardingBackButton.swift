//
//  OnBoardingBackButton.swift
//  OnBoarding
//
//  Created by SHIRAISHI HIROYUKI on 2026/05/07.
//

import SwiftUI

/// 前のページへ戻る円形ボタン
///
/// 画面左上に固定配置される。
struct OnBoardingBackButton: View {

    /// SFSymbolsのアイコン名
    var imageSystemName: String = "chevron.left"

    /// タップ時に呼ばれるアクション
    let action: () -> Void

    // MARK: - Constants

    private enum Metrics {
        /// アイコンのフレーム幅
        static let iconWidth: CGFloat = 20
        /// アイコンのフレーム高さ
        static let iconHeight: CGFloat = 30
        /// 左端からのパディング
        static let leadingPadding: CGFloat = 15
        /// 上端からのパディング
        static let topPadding: CGFloat = 5
    }

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            Image(systemName: imageSystemName)
                .font(.title3)
                .frame(width: Metrics.iconWidth, height: Metrics.iconHeight)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading, Metrics.leadingPadding)
        .padding(.top, Metrics.topPadding)
    }
}

#Preview {
    OnBoardingBackButton {

    }
}
