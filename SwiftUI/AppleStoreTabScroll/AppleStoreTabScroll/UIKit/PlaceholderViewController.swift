//
//  PlaceholderViewController.swift
//  AppleStoreTabScroll
//
//  Created by SHIRAISHI HIROYUKI on 2026/04/11.
//

import UIKit

/// 各タブのプレースホルダー画面
final class PlaceholderViewController: UIViewController {

    // MARK: - プロパティ

    private let labelText: String

    // MARK: - 初期化

    init(labelText: String) {
        self.labelText = labelText
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ライフサイクル

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = "\(labelText)の遷移先"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
