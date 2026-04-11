//
//  UIKitTabBarController.swift
//  AppleStoreTabScroll
//
//  Created by SHIRAISHI HIROYUKI on 2026/04/11.
//

import UIKit

final class UIKitTabBarController: UITabBarController {

    // MARK: - 閉じるためのコールバック

    var onDismiss: (() -> Void)?

    // MARK: - タブバーの表示/非表示状態

    /// タブバーが隠れているか
    var isTabBarHiddenByScroll = false

    // MARK: - UI

    /// タブバーの下に表示するアクセサリラベル
    let accessoryLabel: UILabel = {
        let label = UILabel()
        label.text = "98000円から、初回購入10%オフ！\nクーポンコード: WELCOME10"
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var accessoryBottomConstraint: NSLayoutConstraint!

    // MARK: - ライフサイクル

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupCloseButton()
        setupAccessoryLabel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // システムがタブバーの位置をリセットするので、毎回再適用する
        if isTabBarHiddenByScroll {
            tabBar.frame.origin.y = view.frame.height
            accessoryBottomConstraint.constant = -(view.safeAreaInsets.bottom + 4)
        } else {
            accessoryBottomConstraint.constant = -(tabBar.frame.height + view.safeAreaInsets.bottom + 4)
        }
    }

    // MARK: - publicメソッド

    /// タブバーの表示/非表示をアニメーション付きで切り替え
    func setTabBarVisible(_ visible: Bool) {
        guard isTabBarHiddenByScroll != !visible else { return }
        isTabBarHiddenByScroll = !visible

        let targetY: CGFloat = visible
            ? view.frame.height - tabBar.frame.height - view.safeAreaInsets.bottom
            : view.frame.height

        let accessoryConstant: CGFloat = visible
            ? -(tabBar.frame.height + view.safeAreaInsets.bottom + 4)
            : -(view.safeAreaInsets.bottom + 4)

        UIView.animate(withDuration: 0.3) {
            self.tabBar.frame.origin.y = targetY
            self.accessoryBottomConstraint.constant = accessoryConstant
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - プライベートメソッド

    private func setupTabs() {
        // 4タブグループ
        let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
        let forYouVC = storyboard.instantiateViewController(withIdentifier: "ForYouViewController")

        let forYouTab = UITab(
            title: "For You",
            image: UIImage(systemName: "heart.text.square.fill"),
            identifier: "forYou"
        ) { _ in
            UINavigationController(rootViewController: forYouVC)
        }

        let productsTab = UITab(
            title: "Products",
            image: UIImage(systemName: "macbook.and.iphone"),
            identifier: "products"
        ) { _ in
            UINavigationController(rootViewController: PlaceholderViewController(labelText: "Products"))
        }

        let moreTab = UITab(
            title: "More",
            image: UIImage(systemName: "safari"),
            identifier: "more"
        ) { _ in
            UINavigationController(rootViewController: PlaceholderViewController(labelText: "More"))
        }

        let bagTab = UITab(
            title: "Bag",
            image: UIImage(systemName: "bag"),
            identifier: "bag"
        ) { _ in
            UINavigationController(rootViewController: PlaceholderViewController(labelText: "Bag"))
        }

        // 検索タブ（別グループ、SwiftUIの Tab(role: .search) と同等）
        let searchTab = UISearchTab { _ in
            UINavigationController(rootViewController: PlaceholderViewController(labelText: "Search"))
        }

        tabs = [forYouTab, productsTab, moreTab, bagTab, searchTab]
    }

    private func setupAccessoryLabel() {
        view.addSubview(accessoryLabel)
        accessoryBottomConstraint = accessoryLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            accessoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            accessoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            accessoryBottomConstraint
        ])
    }

    private func setupCloseButton() {
        // UITab APIではviewControllersにタブ切り替え後にVCが入るため、
        // 各タブのrootVCのnavigationItemに閉じるボタンを設定
        for tab in tabs {
            guard let nav = tab.viewController as? UINavigationController,
                  let rootVC = nav.viewControllers.first else { continue }
            rootVC.navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "SwiftUI版に戻る",
                style: .plain,
                target: self,
                action: #selector(closeTapped)
            )
        }
    }

    // MARK: - ハンドラー

    @objc private func closeTapped() {
        onDismiss?()
    }
}
