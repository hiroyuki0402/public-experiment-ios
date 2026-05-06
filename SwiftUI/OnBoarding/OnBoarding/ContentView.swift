//
//  ContentView.swift
//  OnBoarding
//
//  Created by SHIRAISHI HIROYUKI on 2026/05/07.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        OnBoardingView(items: [
            .init(id: 0, title: "アプリアイコンの押下", subtitle: "FridgeScanアプリを起動しよう！", fallbackImage: "0"),
            .init(id: 1, title: "起動中のスプラッシュ画面", subtitle: "ローディング完了までまとう", fallbackImage: "1"),
            .init(id: 2, title: "ホーム画面", subtitle: "今日のトピックなど確認しよう", fallbackImage: "2"),
            .init(id: 3, title: "食材画面", subtitle: "いろんな食材を見てみよう", fallbackImage: "3"),
            .init(id: 4, title: "レシピー画面", subtitle: "レシピーから今日の献立を決めよう", fallbackImage: "4"),
            .init(id: 5, title: "買い物リスト", subtitle: "足りない食事をメモしよう", fallbackImage: "5"),
            .init(id: 6, title: "設定画面", subtitle: "プッシュ通知など設定を行おう", fallbackImage: "6"),
        ]) {
            print("完了")
        }
    }
}

#Preview {
    ContentView()
}
