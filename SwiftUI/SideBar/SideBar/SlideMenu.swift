//
//  SlideMenu.swift
//  SideBar
//
//  Created by SHIRAISHI HIROYUKI on 2026/06/01.
//

import SwiftUI

/// スライド式サイドメニューのコンテナ
/// 左端からのスワイプジェスチャーでメニューを開閉し、メインコンテンツを右にスライドさせる
/// - menuContent: サイドメニューとして表示するビュー
/// - content: メインコンテンツのビュー
struct SlideMenu<MenuContent: View, Content: View>: View {
    /// ジェスチャーの有効/無効を外部から制御する
    var isEnable: Bool = true

    /// サイドメニューの幅
    var menuWidth: CGFloat = 280

    /// メニューの展開状態
    @Binding var isExpanded: Bool
    @ViewBuilder var menuContent: (_ progress: CGFloat) -> MenuContent
    @ViewBuilder var content: (_ progress: CGFloat) -> Content

    /// メニューの開閉進捗（0: 閉じている、1: 完全に開いている）
    @State private var progress: CGFloat = .zero

    /// メインコンテンツの水平オフセット
    @State private var xOffset: CGFloat = 0

    /// 触覚フィードバックのトリガー
    @State private var haptics: Bool = false

    /// メニュー閉じた状態の最小スケール
    private let menuMinScale: CGFloat = 0.95

    /// メニュー開閉時のスケール変化量
    private let menuScaleRange: CGFloat = 0.05

    /// コンテンツの影の最大透明度
    private let shadowMaxOpacity: CGFloat = 0.06

    /// コンテンツの影の半径
    private let shadowRadius: CGFloat = 5.0

    /// コンテンツの影のXオフセット
    private let shadowOffsetX: CGFloat = -10.0

    /// オーバーレイの枠線の幅
    private let overlayBorderWidth: CGFloat = 1.0

    /// ジェスチャーの速度を減衰させる割合
    private let velocityDamping: CGFloat = 5.0

    /// アニメーションの持続時間
    private let animationDuration: TimeInterval = 0.2

    /// アニメーションのバウンス量
    private let animationBounce: Double = 0.02

    // MARK: - ボディ

    var body: some View {
        ZStack(alignment: .leading) {
            menuView
            contentView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(.rect)
        .gesture(
            CustomSideMenuGesture(isEnabled: isEnable, isExpanded: $isExpanded) { gesture in
                handleGesture(gesture)
            }
        )
        .sensoryFeedback(.impact(weight: .light), trigger: haptics)
        .onChange(of: isExpanded) { oldValue, newValue in
            withAnimation(makeAnimation()) {
                if newValue && progress != 1 {
                    expandMenu()
                }

                if !newValue && progress != 0 {
                    dismissMenu()
                }
            }
        }
    }

    // MARK: - private Method

    /// メニュー展開中にコンテンツ上に表示するオーバーレイ
    /// タップするとメニューを閉じる
    @ViewBuilder
    private func makeContentOverlay() -> some View {
        makeBackgroundShape()
            .fill(.fill.tertiary)
            .stroke(.fill.secondary, lineWidth: overlayBorderWidth)
            .ignoresSafeArea()
            .contentShape(.rect)
            .onTapGesture {
                withAnimation(makeAnimation()) {
                    dismissMenu()
                }
            }
            .opacity(progress)
    }

    /// ジェスチャーの状態に応じてオフセットと進捗を更新する
    /// ドラッグ中はオフセットをリアルタイムに追従させ、指を離したら速度を加味して開閉を決定する
    private func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let state = gesture.state
        let translation = gesture.translation(in: gesture.view).x + (isExpanded ? menuWidth : 0)
        let velocity = gesture.velocity(in: gesture.view).x / velocityDamping

        if state == .began || state == .changed {
            xOffset = min(max(translation, 0), menuWidth)
            progress = xOffset / menuWidth
        } else {
            withAnimation(makeAnimation()) {
                if (xOffset + velocity) > (menuWidth / 2) {
                    expandMenu()
                } else {
                    dismissMenu()
                }
            }
        }
    }

    /// メニューを完全に展開する
    private func expandMenu() {
        if !isExpanded { haptics.toggle() }
        xOffset = menuWidth
        progress = 1
        isExpanded = true
    }

    /// メニューを閉じて初期状態に戻す
    private func dismissMenu() {
        if isExpanded { haptics.toggle() }
        xOffset = 0
        progress = 0
        isExpanded = false
    }

    /// コンテンツの背景形状
    /// iOS 26 以降はデバイスの角丸に追従する `ConcentricRectangle` を、それ以前は固定の `RoundedRectangle` を使う
    private func makeBackgroundShape() -> some Shape {
        if #available(iOS 26, *) {
            return ConcentricRectangle(corners: .concentric, isUniform: true)
        } else {
            return RoundedRectangle(cornerRadius: 45)
        }
    }

    /// メニュー開閉に使用するスプリングアニメーション
    private func makeAnimation() -> Animation {
        .interactiveSpring(duration: animationDuration, extraBounce: animationBounce)
    }
}

// MARK: - サブビュー

private extension SlideMenu {

    /// サイドメニュー: 進捗に応じてフェードイン+スケールアップする
    var menuView: some View {
        menuContent(progress)
            .frame(width: menuWidth)
            .frame(maxHeight: .infinity)
            .opacity(progress)
            .scaleEffect(menuMinScale + (menuScaleRange * progress))
    }

    /// メインコンテンツ: メニューが開くと右にスライドし、半透明のオーバーレイがかかる
    var contentView: some View {
        content(progress)
            .containerRelativeFrame(.horizontal)
            .frame(maxHeight: .infinity)
            .background {
                makeBackgroundShape()
                    .fill(.background)
                    .ignoresSafeArea()
            }
            .overlay {
                makeContentOverlay()
            }
            .mask {
                makeBackgroundShape()
                    .ignoresSafeArea()
            }
            .compositingGroup()
            .shadow(color: .black.opacity(shadowMaxOpacity * progress), radius: shadowRadius, x: shadowOffsetX, y: 0)
            .offset(x: xOffset)
    }
}

#Preview {
    ContentView()
}
