//
//  ForYouView.swift
//  AppleStoreTabScroll
//
//  Created by SHIRAISHI HIROYUKI on 2026/04/11.
//

import SwiftUI

struct ForYouView: View {

    /// スクロール方向が上向きかどうか
    @State private var isScrolledUp: Bool = false
    /// スクロール方向が切り替わった時点のオフセット
    @State private var storedOffset: CGFloat = 0
    /// 現在のスクロールフェーズ
    @State private var scrollPhase: ScrollPhase = .idle
    /// タブバーの表示状態
    @State private var tabBarVisibility: Visibility = .visible

    // MARK: - ボディー

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 12) {
                ForEach(1...50, id: \.self) { index in
                    Rectangle()
                        .fill(.fill.tertiary)
                        .frame(height: 50)
                        .overlay {
                            Text("\(index)")
                        }
                }
            }
            .padding(15)
        }
        // スクロールインジケーターを非表示
        .scrollIndicators(.hidden)

        // スクロール位置の変化を監視してタブバーの表示/非表示を制御
        .onScrollGeometryChange(for: CGFloat.self) {
            // コンテンツのオフセットとインセットから実際のスクロール位置を算出
            $0.contentOffset.y + $0.contentInsets.top
        } action: { oldValue, newValue in
            let threshold: CGFloat = 50
            let isScrolledUp = oldValue < newValue

            // スクロール方向が変わったら基準オフセットを更新
            if self.isScrolledUp != isScrolledUp {
                let optionalDownThreshold: CGFloat = 10

                // タブバーが隠れている場合はしきい値分を補正
                storedOffset = newValue - (tabBarVisibility == .hidden ? (threshold + optionalDownThreshold) : 0)
                self.isScrolledUp = isScrolledUp
            }

            let diff = newValue - storedOffset
            // ユーザーが操作中のみタブバーの表示切り替えを判定
            if scrollPhase == .interacting {
                tabBarVisibility = diff > threshold ? .hidden : .visible
            }
        }

        // スクロールフェーズの変化を追跡
        .onScrollPhaseChange { _, newPhase in
            scrollPhase = newPhase
        }

        // タブバーの表示状態を反映
        .toolbarVisibility(tabBarVisibility, for: .tabBar)

        // タブバーの表示切り替えをアニメーション
        .animation(.smooth(duration: 0.3, extraBounce: 0), value: tabBarVisibility)
    }
}
