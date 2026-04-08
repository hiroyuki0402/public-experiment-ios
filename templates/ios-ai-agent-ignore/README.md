# iOS AI Agent Ignore Files

iOSプロジェクトをAIエージェント（Cursor, Claude Code, Copilot, Antigravity, Gemini CLI）で扱うときの除外設定まとめ。

## なぜ3層に分けるのか

AIの除外は「全部見せる」か「全部隠す」の二択じゃない。
pbxprojみたいに「読ませたいけど書かせたくない」ファイルがiOSには大量にあるから、
アクセスレベルを3段階に分けてる。

| 層 | 何を？ | どうする？ |
|---|---|---|
| 第1層：完全除外 | バイナリ、ビルド成果物、シークレット、画像 | AIに一切見せない |
| 第2層：編集禁止 | pbxproj, storyboard, xib, xcdatamodeld | 読ませるけど書かせない |
| 第3層：インデックス除外 | ロックファイル、コード生成出力、SPM内部 | 普段の検索から外す。手動参照はできる |

## ファイル一覧

| ファイル | 対象ツール | やってること |
|---|---|---|
| .cursorignore | Cursor | 書いたファイルをAIが一切読めなくする |
| .cursorindexingignore | Cursor | 自動検索からは外すけど、手動で指定すれば読める |
| .claude/settings.json | Claude Code | ファイルごとに読み取り禁止・編集禁止を設定 |
| .copilotignore | GitHub Copilot | コミュニティ拡張用。公式は未実装 |
| .aiexclude | Antigravity / Gemini Code Assist | Googleエコシステム共通の除外設定 |
| .geminiignore | Gemini CLI | CLI専用の除外設定 |
| .vscode/settings.reference.json | VS Code / Cursor | 検索結果から除外する参考設定。手動マージ必要 |

## 除外しちゃダメなもの（AIに見せるべき）

- *.swift — ソースコード。当たり前
- *.metal — Metal Shader。テキストだからAIが普通に読める
- *.xcconfig — ビルド設定。AIがビルド構成を理解するのに必要
- *.entitlements — アプリの権限宣言
- Info.plist — アプリのメタデータ
- Package.swift / Podfile / Cartfile — 依存定義
- *.xctestplan — テストプラン
- *.intentdefinition — SiriKit / App Intents
- .xcdatamodeld/ — CoreDataモデル（ただし読み取りのみ。編集は禁止）
- Documentation.docc/ — DocCドキュメント
- Fastfile / Appfile — fastlane設定
- .github/ — CI/CDワークフロー
- Contents.json（xcassets内）— カラー値やシンボル名の定義。残す価値あり
- *.storyboard / *.xib — プロジェクト方針次第で除外しなくてもOK。ただしAIが勝手に大量編集したりファイル追加するのは危ないので、.cursorrules や CLAUDE.md に「storyboard/xib の修正行数が多い場合・ファイル追加する場合は必ず確認を取る」ルールを入れておく

## プロジェクトに合わせて調整するところ

**storyboard / xib の扱い**
→ デフォルトは .cursorindexingignore に入れてある（自動検索から外すだけ）
→ 除外せずAIに見せる方針なら .cursorindexingignore から該当行を削除
→ その場合は .cursorrules や CLAUDE.md で「大量変更時・ファイル追加時は確認」ルールを追加
→ 完全に不要なら .cursorignore に移動して完全除外

**XcodeGen / Tuist 使ってる場合**
→ *.xcodeproj/ ごと .cursorignore に入れて完全除外
→ project.yml（XcodeGen）や Project.swift（Tuist）をAIに見せる
→ pbxproj問題の根本解決

**Xcode 16 Buildable Folders 使ってる場合**
→ pbxprojが大幅に軽くなるので、.cursorindexingignore から外してもOK

**R.swift / SwiftGen 使ってる場合**
→ 生成ファイル（R.generated.swift 等）は除外済み
→ Sourceryで型インデックス生成 → .cursor/rules/ に配置する手法もある
