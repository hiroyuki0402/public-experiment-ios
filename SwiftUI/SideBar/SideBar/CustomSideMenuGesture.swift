//
//  CustomSideMenuGesture.swift
//  SideBar
//
//  Created by SHIRAISHI HIROYUKI on 2026/06/01.
//

import SwiftUI

/// サイドメニュー用のカスタムパンジェスチャー
/// 水平スクロール(ScrollView等)と競合しないよう、ジェスチャーの開始条件と優先度を制御する
struct CustomSideMenuGesture: UIGestureRecognizerRepresentable {
    var isEnabled: Bool
    @Binding var isExpanded: Bool
    var handle: (UIPanGestureRecognizer) -> ()

    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer()
        gesture.delegate = context.coordinator
        gesture.maximumNumberOfTouches = 1
        return gesture
    }

    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        recognizer.isEnabled = isEnabled
    }

    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        handle(recognizer)
    }

    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: CustomSideMenuGesture
        init(parent: CustomSideMenuGesture) {
            self.parent = parent
        }

        /// 水平方向のスワイプのみ受け付ける
        /// 右スワイプは常に許可、左スワイプはメニュー展開中のみ許可する
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
                let velocity = panGesture.velocity(in: panGesture.view)
                let isHorizontalSwipe = abs(velocity.x) > abs(velocity.y)

                return (isHorizontalSwipe && velocity.x > 0) || (isHorizontalSwipe && velocity.x < 0 && parent.isExpanded)
            }

            return false
        }

        /// ScrollViewが左端(offset <= 0)のとき、このジェスチャーを優先させる
        /// これによりスクロール中はサイドメニューが誤って開かないようにする
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            if let scrollview = otherGestureRecognizer.view as? UIScrollView {
                let offset = scrollview.contentOffset.x
                return offset <= 0
            }

            return false
        }
    }
}
