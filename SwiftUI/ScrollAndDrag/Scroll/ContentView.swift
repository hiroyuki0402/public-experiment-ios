//
//  ContentView.swift
//  Scroll
//
//  Created by SHIRAISHI HIROYUKI on 2024/09/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let safeAreaInsets = $0.safeAreaInsets
            Home(safeAreaInsets: safeAreaInsets)
        }
    }
}


struct Home: View {
    let safeAreaInsets: EdgeInsets
    @State private var selectedContent: ListContent?
    @State private var selectedContentScal: CGFloat = 1.0
    @State private var selectedContentFrame: CGRect = .zero
    @State private var isHaptics: Bool = false
    @State private var offset: CGSize = .zero
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var currentScroll: CGFloat = 0
    @State private var lastActiveScrollOfset: CGFloat = 0
    @State private var topRegion: CGRect = .zero
    @State private var bottomRegion: CGRect = .zero
    @State private var maxmumScrollSize: CGFloat = 0
    @State private var timer: Timer?
    @State private var contents: ListContents = [
        .init(systemName: "person.crop.circle.fill", title: "マイページ"),
        .init(systemName: "star.fill", title: "お気に入り"),
        .init(systemName: "gear", title: "各種設定"),
        .init(systemName: "star.square.fill", title: "キャンペーン"),
        .init(systemName: "lightbulb.max.fill", title: "トピック"),
        .init(systemName: "message.fill", title: "問い合わせ"),
        .init(systemName: "iphone.and.arrow.forward.outward", title: "ログアウト"),
        .init(systemName: "document", title: "規約"),
        .init(systemName: "applelogo", title: "バージョン"),
    ]

    @State private var showMode: Bool = false
    @State private var gridCount: Int = 1

    fileprivate let colors: [Color] = [.blue, .orange, .yellow, .red]

    @State var effect: Bool = false
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: gridCount), spacing: 10) {
                ForEach($contents) { $content in
                    ListRow(content: content, effect: effect)
                        /// 選択されたコンテンツが現在のコンテンツと一致するかどうかに基づいて透明度を調整
                        .opacity(selectedContent?.id == content.id ? 0: 1)

                        /// 各コンテンツの位置変更を監視し、新しい値をアクションで受け取る
                        .onGeometryChange(for: CGRect.self) {
                            /// グローバル座標内でフレームを取得する
                            $0.frame(in: .global)

                        } action: { newValue in
                            /// 選択されたコンテンツとターゲットコンテンツのIDが一致する場合、選択されたコンテンツのフレームを更新
                            if isCheckID(sourceID: selectedContent?.id, targetID: content.id) {

                                /// 選択されたコンテンツのフレームを新しい値に設定する
                                selectedContentFrame = newValue
                            }

                            /// コンテンツのフレームを新しい値に設定する
                            content.frame = newValue
                        }

                        /// ドラッグ＆ドロップジェスチャーをコンテンツに適用
                        .gesture(gesture(content))

                }
            }
            .padding(25)
        }
        /// スクロールビューの位置をStateバインディングを通じて監視し、更新する
        .scrollPosition($scrollPosition)

        /// スクロール時にYオフセットを監視し、変化があった場合に現在のスクロール位置を更新する
        .onScrollGeometryChange(for: CGFloat.self, of: {
            /// コンテンツのYオフセットとコンテンツの上部インセットを合計
            $0.contentOffset.y + $0.contentInsets.top

        }, action: { oldValue, newValue in
            /// 新しいスクロール位置をState変数に設定
            currentScroll = newValue
        })
        /// スクロールビューの最大スクロールサイズを計算し、変化があった場合に更新する
        .onScrollGeometryChange(for: CGFloat.self, of: {
            /// コンテンツサイズとコンテナサイズの差を計算する
            $0.contentSize.height - $0.containerSize.height

        }, action: { oldValue, newValue in
            /// 新しい最大スクロールサイズをState変数に設定する
            maxmumScrollSize = newValue
        })
        /// 選択されたコンテンツが存在する場合、そのコンテンツをオーバーレイ
        .overlay(alignment: .topLeading) {
            if let selectedContent {

                /// 選択されたコンテンツ用のリスト行を表示する
                ListRow(content: selectedContent, effect: effect)
                    /// 選択されたコンテンツの元のフレームに基づいてサイズを設定する
                    .frame(width: selectedContent.frame.width, height: selectedContent.frame.height)

                    /// 選択されたコンテンツの拡大縮小効果を適用する
                    .scaleEffect(selectedContentScal)

                    /// 選択されたコンテンツの位置をオフセットで調整
                    .offset(x: selectedContent.frame.minX, y: selectedContent.frame.minY)

                    /// 追加のオフセットを適用する
                    .offset(offset)

                    /// 安全領域を無視して全画面で表示する
                    .ignoresSafeArea()

                    /// アイデンティティトランジションを使用してビューの変更を適用します。
                    .transition(.identity)
            }
        }
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.clear)

                /// 上部バッファーゾーンの高さを設定します。
                .frame(height: 20 + safeAreaInsets.top)

                /// グローバル座標内でフレームを取得し、その値を更新
                .onGeometryChange(for: CGRect.self, of: {
                    /// グローバル座標でのフレームを取得
                    $0.frame(in: .global)

                }, action: { newValue in
                    /// 上部バッファーゾーンの新しい領域を設定
                    topRegion = newValue
                })
                /// 上部の安全領域のオフセットを適用
                .offset(y: -safeAreaInsets.top)

                /// タイトニングを無効
                .allowsTightening(false)
        }
        .overlay(alignment: .bottom) {
            /// 下部バッファーゾーンのレクタングルを追加
            Rectangle()
                .frame(height: 20 + safeAreaInsets.bottom)

            /// グローバル座標でフレームの変更を監視して更新
                .onGeometryChange(for: CGRect.self, of: {
                    /// グローバル座標でのフレームを取得
                    $0.frame(in: .global)

                }, action: { newValue in

                    /// 下部バッファーゾーンの新しい領域を設定
                    bottomRegion = newValue
                })

                /// 下部の安全領域のオフセットを適用
                .offset(y: safeAreaInsets.bottom)

                /// タイトニングを無効
                .allowsTightening(false)
        }
        .overlay(alignment: .bottomTrailing) {
                  Button {
                      showMode.toggle()
                      effect = true
                      if showMode {
                          gridCount = 2
                      } else {
                          gridCount = 1
                      }
                  } label: {
                      Image(systemName: showModeSystemname())
                          .font(.title)
                          .foregroundStyle(
                              LinearGradient(gradient: Gradient(colors: colors), startPoint: .bottom, endPoint: .top)
                          )
                          .frame(width: 50, height: 50)
                          .background(.gray)
                          .clipShape(RoundedRectangle(cornerRadius: 10))
                          .padding(.bottom, 50)
                          .padding(.horizontal, 15)
                          .symbolEffect(.bounce, options: .nonRepeating, isActive: effect)
                          .shadow(radius: 10)
                  }
              }
        /// タイトニングが有効な状態を設定し、選択されたコンテンツがない場合に有効化
        .allowsTightening(selectedContent == nil)
        /// 触覚フィードバックを設定
        .sensoryFeedback(.impact, trigger: isHaptics)
        .background(
            LinearGradient(gradient: Gradient(colors: colors), startPoint: .bottom, endPoint: .top)
        )

    }

    /// グリッド表示モードのアイコン名を切り替え
    private func showModeSystemname() -> String {
        return showMode ? "list.bullet": "rectangle.grid.2x2.fill"
    }

    /// ロングプレスとドラッグジェスチャーを組み合わせたジェスチャーを返す
    private func gesture(_ content: ListContent) -> some Gesture {
        LongPressGesture(minimumDuration: 0.25)
            /// ロングプレス後にドラッグジェスチャーを連続して実行
            .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .global))

            /// ジェスチャーの変更を監視し、処理実行
            .onChanged { value in
                /// ジェスチャーの第二フェーズ（ドラッグ）が発生した場合、処理を行う
                switch value {
                case .second(let isChange, let value):

                    /// ドラッグが発生している場合、ドラッグの詳細を処理する
                    if isChange {
                        /// ドラッグジェスチャーの詳細を処理
                        second(value: value, content)
                        effect = true
                    }
                default: ()
                }
            }.onEnded { _ in
                /// ジェスチャーが終了した場合、タイマーを無効
                timer?.invalidate()

                /// 選択されたコンテンツの位置とスケールを元に戻してオフセットをリセット
                withAnimation(.snappy(duration: 0.25), completionCriteria: .logicallyComplete) {
                    /// 選択されたコンテンツのフレームとスケールをリセット
                    selectedContent?.frame = selectedContentFrame

                    /// スケールをデフォルト値に戻す
                    selectedContentScal = 1.0

                    /// オフセットをリセット
                    offset = .zero
                } completion: {
                    /// ジェスチャーが完了した後、選択されたコンテンツをクリアし、タイマーをリセット
                    selectedContent = nil
                    timer = nil
                    lastActiveScrollOfset = 0
                }
            }
    }

    /// ドラッグの詳細を処理し、必要に応じて自動スクロールを行う
    private func second(value: DragGesture.Value?, _ content: ListContent) {
        /// 選択されたコンテンツがない場合、現在のコンテンツを選択し、フレームとスクロール位置を設定する
        if selectedContent == nil {
            /// 現在のコンテンツを選択状態に設定
            selectedContent = content

            /// 選択されたコンテンツのフレームを現在のフレームに設定
            selectedContentFrame = content.frame

            /// 最後にアクティブだったスクロール位置を更新
            lastActiveScrollOfset = currentScroll

            /// 触覚フィードバックをトグルする
            isHaptics.toggle()

            /// 選択されたコンテンツのスケールを少し大きく設定
            withAnimation(.smooth(duration: 0.25, extraBounce: 0)) {
                selectedContentScal = 1.05
            }
        }

        /// ドラッグの詳細がある場合、オフセットと位置を更新し、必要に応じて自動スクロールを実行
        if let value {
            /// ドラッグの翻訳をオフセットに設定
            offset = value.translation

            /// ドラッグの位置を取得
            let location = value.location

            /// ドラッグの位置に基づいて自動スクロールをチェックし、必要に応じて実行
            checkAndScroll(location)
        }
    }

    /// ドラッグの位置に応じて自動スクロールをチェックし、アイテムの入れ替えを行う
    private func checkAndScroll(_ location: CGPoint) {
        /// ドラッグの位置が上部バッファーゾーンにあるかどうかをチェック
        let topStatus = topRegion.contains(location)

        /// ドラッグの位置が下部バッファーゾーンにあるかどうかをチェック
        let bottomStatus = bottomRegion.contains(location)

        /// 上部または下部バッファーゾーンに位置する場合、自動スクロールを開始
        if topStatus || bottomStatus {

            /// タイマーが設定されていない場合にのみ新しいタイマーを設定
            guard timer == nil else { return }

            /// タイマーを設定し、定期的にスクロール位置を更新し、アイテムの入れ替えをチェック
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
                if topStatus {
                    /// 上部バッファーゾーンに位置する場合、スクロール位置を減少させます。
                    lastActiveScrollOfset = max(lastActiveScrollOfset - 10, 0)
                } else {
                    /// 下部バッファーゾーンに位置する場合、スクロール位置を増加
                    lastActiveScrollOfset = lastActiveScrollOfset + 10
                }
                /// 新しいスクロール位置にスクロールビューを移動
                scrollPosition.scrollTo(y: lastActiveScrollOfset)

                /// 新しい位置に応じてアイテムの入れ替えをチェック
                checkAndSwapItems(location)
            })
        } else {
            /// ドラッグの位置がバッファーゾーンにない場合、タイマーを無効にしてアイテムの入れ替えをチェック
            timer?.invalidate()
            timer = nil
            checkAndSwapItems(location)
        }
    }

    /// ドラッグの位置に応じてアイテムの入れ替えをチェックして必要に応じて入れ替えを行う
    private func checkAndSwapItems(_ location: CGPoint) {
        /// 選択されたアイテムのインデックスを取得
        if let currentIndex = contents.firstIndex(where: { $0.id == selectedContent?.id}),
           /// ドラッグされたアイテムの位置にあるアイテムのインデックスを取得
           let fallingIndex = contents.firstIndex(where: { $0.frame.contains(location)}) {
            /// アイテムの位置を入れ替える
            withAnimation(.smooth(duration: 0.25, extraBounce: 0)) {
                /// 入れ替えたアイテムの位置をアニメーションで更新
                (contents[currentIndex], contents[fallingIndex]) = (contents[fallingIndex], contents[currentIndex])
            }
        }
    }

    /// ソースIDとターゲットIDが一致するかどうかをチェック
    private func isCheckID(sourceID: String?, targetID: String?) -> Bool {
        return sourceID == targetID
    }
}



struct ListRow: View {
    let content: ListContent
    @State var effect: Bool = false

    var body: some View {
        HStack() {
            Image(systemName: content.systemName)
                .resizable()
                .symbolEffect(.breathe, isActive: effect)
                .frame(width: 30, height: 30)
                .padding(.horizontal, 5)
                .foregroundStyle(
                    LinearGradient(gradient: Gradient(colors: [.blue, .orange, .yellow, .red]), startPoint: .bottom, endPoint: .top)
                )
            Text(content.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .shadow(radius: 10)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 10)
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
        }
    }
}

struct ListContent: Identifiable, Hashable {
    let id = UUID().uuidString
    let systemName: String
    let title: String
    var frame: CGRect = .zero
}

typealias ListContents = [ListContent]


#Preview {
    ContentView()
}


extension Color {
    static func random() -> Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}
