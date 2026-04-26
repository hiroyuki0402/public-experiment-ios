//
//  ContentView.swift
//  GlassTabBar
//
//  Created by SHIRAISHI HIROYUKI on 2026/04/23.
//

import SwiftUI

struct ContentView: View {

    @State private var activeTab: TabItems = .home

    var body: some View {
        VStack {
            TabView {
                ForEach(TabItems.allCases, id: \.self) { tab in
                    Tab(tab.title, systemImage: tab.icon) {
                        tab.content
                    }
                }
            }
            .shadow(radius: 10)
            
            MainTabBarView()
                .padding(.horizontal, 20)
                .shadow(radius: 10)
        }
        .ignoresSafeArea(.all)
        .padding()
    }

    @ViewBuilder
    func MainTabBarView() -> some View {
        GlassEffectContainer(spacing: 10) {
            HStack(spacing: 10) {
                GeometryReader {
                    Tabbar(
                        size: $0.size,
                        barTint: .gray.opacity(0.3),
                        activeTab: $activeTab) { tab in

                        VStack(spacing: 3) {
                            Image(systemName: tab.symbol)
                                .font(.title3)

                            Text(tab.rawValue)
                                .font(.system(size: 10))
                                .fontWeight(.medium)
                        }
                        .symbolVariant(.fill)
                        .frame(maxWidth: .infinity)
                    }
                    .glassEffect(.regular.interactive(), in: .capsule)
                }

                ZStack {
                    ForEach(TabItems.allCases, id: \.rawValue) { tab in
                        Image(systemName: tab.actionSymbol)
                            .font(.system(size: 22, weight: .medium))
                            .blurFade(activeTab == tab)
                    }
                }
                .frame(width: 55, height: 55)
                .glassEffect(.regular.interactive(), in: .capsule)
                .animation(.smooth(duration: 0.55, extraBounce: 0), value: activeTab)
            }
        }
        .frame(height: 55)
    }
}

#Preview {
    ContentView()
}
