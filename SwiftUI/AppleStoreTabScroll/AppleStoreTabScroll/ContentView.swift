//
//  ContentView.swift
//  AppleStoreTabScroll
//
//  Created by SHIRAISHI HIROYUKI on 2026/04/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Tab(tab.title, systemImage: tab.icon) {
                    tab.content
                }
            }

            Tab(role: .search) {
                // TODO: 検索押したときのAction
            }
        }
        .tabViewBottomAccessory {
            Text("98000円から、初回購入10%オフ！クーポンコード: WELCOME10")
                .font(.caption)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Tabのアイテム

enum AppTab: CaseIterable {
    case forYou
    case products
    case more
    case bag

    var title: String {
        switch self {
        case .forYou:
            "For You"
        case .products:
            "Products"
        case .more:
            "More"
        case .bag:
            "Bag"
        }
    }

    var icon: String {
        switch self {
        case .forYou:
            "heart.text.square.fill"
        case .products:
            "macbook.and.iphone"
        case .more:
            "safari"
        case .bag:
            "bag"
        }
    }

    @ViewBuilder
    var content: some View {
        switch self {
        case .forYou:
            ForYouView()
        case .products:
            Text("productsの遷移先")
        case .more:
            Text("moreの遷移先")
        case .bag:
            Text("bagの遷移先")
        }
    }
}

#Preview {
    ContentView()
}
