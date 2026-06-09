//
//  ContentView.swift
//  SideBar
//
//  Created by SHIRAISHI HIROYUKI on 2026/06/01.
//

import SwiftUI

/// メイン画面
/// `SlideMenu` でサイドバーとメインコンテンツ(タブ+ナビゲーション)を管理する
struct ContentView: View {
    @State private var viewModel = HomeViewModel()

    var body: some View {
        SlideMenu(isEnable: viewModel.isMenuEnabled, isExpanded: $viewModel.isExpanded) { progress in
            SideBar(
                isExpanded: $viewModel.isExpanded,
                path: $viewModel.navigationPath
            )
        } content: { progress in
            NavigationStack(path: $viewModel.navigationPath) {
                TabView(selection: $viewModel.activeTab) {
                    Tab.init("Home", systemImage: "house", value: 0) {
                        ScrollView(.vertical) {
                            VStack(spacing: 20) {
                                ForEach(1...15, id: \.self) { index in
                                    DummyCardView()
                                }
                            }
                            .padding(15)
                        }
                    }

                    Tab.init("Search", systemImage: "magnifyingglass", value: 1) {

                    }

                    Tab.init("Notifications", systemImage: "bell", value: 2) {

                    }

                    Tab.init("Profile", systemImage: "person", value: 3) {

                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {

                        } label: {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                }
                .toolbarVisibility(.hidden, for: .navigationBar)
            }
        }
    }
}

#Preview {
    ContentView()
}
