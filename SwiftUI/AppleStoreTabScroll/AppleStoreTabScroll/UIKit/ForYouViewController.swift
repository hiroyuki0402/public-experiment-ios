//
//  ForYouViewController.swift
//  AppleStoreTabScroll
//
//  Created by SHIRAISHI HIROYUKI on 2026/04/11.
//

import UIKit

final class ForYouViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var lastContentOffset: CGFloat = 0
    /// ユーザーがドラッグ中かどうか
    private var isDragging = false

    // MARK: - ライフサイクル

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
    }

    // MARK: - プライベートメソッド

    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension ForYouViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1)"
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ForYouViewController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDragging = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // ユーザーが指で触ってるときだけ判定（バウンス・慣性では反応させない）
        guard isDragging else {
            lastContentOffset = scrollView.contentOffset.y
            return
        }
        guard let tabBarVC = tabBarController as? UIKitTabBarController else { return }

        let currentOffset = scrollView.contentOffset.y

        // 下スクロール → タブバー隠す
        if currentOffset > lastContentOffset + 10 {
            tabBarVC.setTabBarVisible(false)
        } else if currentOffset < lastContentOffset - 2 {
            // 上スクロール → すぐ表示
            tabBarVC.setTabBarVisible(true)
        }

        lastContentOffset = currentOffset
    }
}
