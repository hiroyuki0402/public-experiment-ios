//
//  RootView.swift
//  AppleStoreTabScroll
//
//  Created by SHIRAISHI HIROYUKI on 2026/04/11.
//

import SwiftUI

struct RootView: View {
    @State private var showUIKit = false

    var body: some View {
        NavigationStack {
            ContentView()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(showUIKit ? "SwiftUI版" : "UIKit版") {
                            showUIKit = true
                        }
                    }
                }
                .fullScreenCover(isPresented: $showUIKit) {
                    UIKitTabBarView()
                        .ignoresSafeArea()
                }
        }
    }
}

// MARK: - UIKitTabBarControllerをSwiftUIでラップ

struct UIKitTabBarView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIKitTabBarController {
        let vc = UIKitTabBarController()
        vc.onDismiss = {
            dismiss()
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: UIKitTabBarController, context: Context) {}
}
