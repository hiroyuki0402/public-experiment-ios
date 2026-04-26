//
//  View+Extension.swift
//  GlassTabBar
//
//  Created by SHIRAISHI HIROYUKI on 2026/04/23.
//

import SwiftUI

extension View {
    
    /// ブラーとフェードを切り替えるモディファイア
    /// - Parameters:
    ///   - status: trueで表示状態、falseでブラー+フェードアウト状態
    ///   - onRadius: 非表示時のブラー半径
    ///   - onOpacity: 表示時の不透明度
    ///   - initialRadius: 表示時のブラー半径
    ///   - initialOpacity: 非表示時の不透明度
    /// - Returns: ブラーと不透明度が適用されたView
    @ViewBuilder
    func blurFade(_ status: Bool,
                  onRadius: CGFloat = 10,
                  onOpacity: Double = 1,
                  initialRadius: CGFloat = 0,
                  initialOpacity: Double = 0) -> some View {
        self.compositingGroup()
            .blur(radius: status ? initialRadius : onRadius)
            .opacity(status ? onOpacity : initialOpacity)
    }
}
