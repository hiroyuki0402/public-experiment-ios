//
//  Tabbar.swift
//  GlassTabBar
//
//  Created by SHIRAISHI HIROYUKI on 2026/04/23.
//

import SwiftUI

/// UISegmentedControlをラップしたガラス風タブバー
struct Tabbar<ItemView: View>: UIViewRepresentable {
    /// タブバー全体のサイズ
    var size: CGSize

    /// 選択中タブのティントカラー
    var activeTint: Color = .primary

    /// タブバー背景のティントカラー
    var barTint: Color = .gray.opacity(0.2)

    /// 非選択タブのティントカラー
    var inActiveTint: Color = .primary.opacity(0.45)

    /// 現在選択されているタブ
    @Binding var activeTab: TabItems

    /// 各タブのアイコンViewを生成するクロージャ
    @ViewBuilder var itemView: (TabItems) -> ItemView


    /// Coordinatorを生成してタブ選択イベントを中継する
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }


    /// UISegmentedControlを生成して各タブのアイコンや色を設定する
    func makeUIView(context: Context) -> UISegmentedControl {
        let items = TabItems.allCases.map(\.rawValue)
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = activeTab.index

        // 各タブのSwiftUI Viewを画像に変換してセグメントにセットする
        for (index, tab) in TabItems.allCases.enumerated() {
            let renderer = ImageRenderer(content: itemView(tab))
            renderer.scale = 2
            // テンプレートモードにしてティントカラーが反映されるようにする
            let image = renderer.uiImage?.withRenderingMode(.alwaysTemplate)
            control.setImage(image, forSegmentAt: index)
        }

        DispatchQueue.main.async {
            for subview in control.subviews {
                // 選択インジケーター以外のUIImageView(背景)を透明にする
                if subview is UIImageView && subview != control.subviews.last {
                    // セグメントの背景画像を非表示にする
                    subview.alpha = 0
                }
            }
        }

        control.selectedSegmentTintColor = UIColor(barTint)
        control.tintColor = UIColor(activeTint)
        control.setTitleTextAttributes([
            .foregroundColor: UIColor(activeTint)
        ], for: .selected)
        control.setTitleTextAttributes([
            .foregroundColor: UIColor(inActiveTint)
        ], for: .normal)

        control.addTarget(context.coordinator, action: #selector(context.coordinator.tabSelected(_:)), for: .valueChanged)
        return control
    }


    /// SwiftUI側の状態変化時に呼ばれる更新処理
    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        // TODO: - -
    }


    /// タブバーの表示サイズを外部から指定されたsizeで返す
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UISegmentedControl, context: Context) -> CGSize? {
        return size
    }


    /// UISegmentedControlのタブ選択イベントをSwiftUIのBindingに中継するCoordinator
    class Coordinator: NSObject {

        /// 親のTabbar構造体への参照
        var parent: Tabbar


        /// 親のTabbarを受け取って保持する
        /// - Parameter parent: 親のTabbar
        init(parent: Tabbar) {
            self.parent = parent
        }


        /// セグメントが選択されたときにactiveTabを更新する
        /// - Parameter control: タップされたUISegmentedControl
        @objc func tabSelected(_ control: UISegmentedControl) {
            parent.activeTab = TabItems.allCases[control.selectedSegmentIndex]
        }
    }
}
