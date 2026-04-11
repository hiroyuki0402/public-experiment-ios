# AppleStoreTabScroll



https://github.com/user-attachments/assets/6114a001-0fd4-4fd4-8e18-36cb0b0f9149



Apple Storeアプリ風のタブバー自動非表示UIをSwiftUIとUIKitの両方で実装した。
NavBarのボタンでSwiftUI版とUIKit版を切り替えられる。

## やってること

- 5タブ構成（For You / Products / More / Bag / Search）
- For Youタブで下スクロールするとタブバーが画面外にスライドして消える
- 上に少しでも戻すとタブバーがすぐ出てくる
- タブバーの下にプロモテキスト（98000円から〜）がくっついてる
- タブバーが消えるとプロモテキストがタブバーのあった位置に下がる


## 各ファイルの解説

### RootView.swift

SwiftUI版とUIKit版の切り替えを担当

NavigationStackでContentViewを表示して、NavBarの右上に「UIKit版」ボタンを置いてる
タップするとfullScreenCoverでUIKit版が全画面表示される

UIKitTabBarViewはUIViewControllerRepresentableで、UIKitTabBarControllerをSwiftUIにラップしたもの。
onDismissコールバックを通じてSwiftUI版に戻るボタンの動作をやっている

### ContentView.swift

SwiftUI版のメイン画面。タブの構成とAppTab enumの定義

TabViewの中でForEachを使ってAppTab.allCasesをループしてタブを生成してる
searchだけTab(role: .search)で別に書いてる。
これはSwiftUIの特殊なイニシャライザで、
通常のTab(title:systemImage:)とは別物。
タブバーには表示されるけどenumには含めない。

.tabViewBottomAccessoryでタブバーの下にプロモテキストを配置してる。
名前の通りタブバーの「下」にくっつくので、タブバーが消えるとテキストはタブバーがあった位置に下がる。

ForEachでTab生成するとき、searchだけTab(role:)で別のイニシャライザだからenumに入れられない。
これはSwiftUIの制約で、4つのenumと1つの手書きで分けるのが正しいやり方。

### ForYouView.swift

SwiftUI版のFor Youタブの中身。
スクロールでタブバーを隠すロジックが全部ここに入ってる

4つのState変数を持ってる。
isScrolledUpはスクロール方向が上向きかどうか。
storedOffsetはスクロール方向が切り替わった時点のオフセット値で、これが表示/非表示判定の基準点になる。
scrollPhaseは今のスクロール状態（idle、interacting、deceleratingなど）。
tabBarVisibilityはタブバーの表示状態（.visibleか.hidden）。

スクロール監視の仕組みはこう

まずonScrollGeometryChangeでスクロール位置を監視して
contentOffset.y + contentInsets.topで実際のスクロール位置を計算して、
oldValue < newValueなら下スクロールと判定する。

スクロール方向が変わったらstoredOffsetを更新する。
ポイントはタブバーが隠れてる状態で方向が変わったとき、threshold + optionalDownThreshold(10)を引いてる。
こうすることで少し上に戻すだけでdiffがthreshold以下になって、すぐタブバーが出てくる仕掛け。

diff（現在のオフセット - 基準点）がthreshold(50pt)を超えたらタブバーを隠して、threshold以下なら表示する。
この判定はscrollPhase == .interactingのときだけ実行するようにしているから
ユーザーが指で触ってるときだけ反応して、バウンスや慣性では反応しない。

onScrollPhaseChangeでscrollPhaseを更新して、
.toolbarVisibility(tabBarVisibility, for: .tabBar)でタブバーの表示/非表示を反映、
.animation(.smooth(duration: 0.3, extraBounce: 0))でアニメーションを付けてる

iOS 18+の新APIを使ってる
復習としてそれぞれ、
onScrollGeometryChangeはスクロール位置の変化を監視するやつ
onScrollPhaseChangeはスクロール状態の変化を追跡するやつ
ScrollPhaseにはidle、interacting、decelerating、animatingなどの状態がある
interactingはユーザーが実際に指で触ってドラッグしてる状態を表す

### UIKitTabBarController.swift

UIKit版のタブバー構成。iOS 18+のUITab / UISearchTab APIを使ってる。

UITabで4つのタブ（For You / Products / More / Bag）を作って、
UISearchTabでsearchタブを作ってる。UISearchTabがSwiftUIのTab(role: .search)に対応する。
UITabは従来のviewControllers = [...]と違って、tabs = [...]でセットする新しいAPI。
これで4タブとsearchタブが別グループになって、SwiftUI版と同じ構成にしてみている

タブバーの表示/非表示はisTabBarHiddenByScrollで状態を管理してる
setTabBarVisible(_:)でアニメーション付きの切り替えを行ってる
表示時はtabBar.frame.origin.yをview.frame.height - tabBar.frame.height - safeAreaInsets.bottomにして、
非表示時はview.frame.heightにして画面外に押し出す

ここで重要なのがviewDidLayoutSubviewsで毎回位置を再適用してること
UITabBarControllerはレイアウトサイクルでtabBarの位置を勝手にリセットしてくるので、
これをやらないとアニメーションで動かしてもすぐ元の位置に戻ってしまう

アクセサリラベルはview.addSubviewでviewに直接追加してる
accessoryBottomConstraintでview.bottomAnchorからのオフセットを制御していて、
タブバー表示時は-(tabBarの高さ + safeAreaの高さ + 4)でタブバーの下に、
タブバー非表示時は-(safeAreaの高さ + 4)でタブバーがあった位置に下がる

SwiftUIだと.tabViewBottomAccessoryの1行で済むことを、UIKitだとview.addSubviewして
AutoLayoutの制約を貼って、タブバーが隠れたときの位置を計算して、viewDidLayoutSubviewsで
リセット対策して...と結構な手間がかかる。
SwiftUIの便利さを実感する部分

閉じるボタンは各タブのnavigationItemにleftBarButtonItemとしてを設置してる。
タップでonDismissコールバックが呼ばれてfullScreenCoverが閉じる

### ForYouViewController.swift

スクロール監視はscrollViewWillBeginDraggingで指が触れたらisDragging = true、
scrollViewDidEndDraggingで指を離したらisDragging = falseにしてる。
scrollViewDidScrollではisDraggingがtrueのときだけ判定する
これがSwiftUI版のscrollPhase == .interactingに対応してて、
バウンスや慣性スクロール中はisDraggingがfalseだから反応しない。

判定ロジックはシンプルで、currentOffset > lastContentOffset + 10で下スクロール10pt以上ならタブバーを隠す。
currentOffset < lastContentOffset - 2で上スクロール2pt以上ならタブバーを表示する。
SwiftUI版と同じで、上に少し戻すだけですぐ出てくる。
下方向は10ptの遊びを入れてて、ちょっとした揺れで隠れないようにしてる

UIKitTabBarControllerのsetTabBarVisible()を呼んで、実際の表示切り替えはそっちに任せてる。


## SwiftUI版とUIKit版の対応関係

| SwiftUI | UIKit |
|---------|-------|
| TabView + Tab | UITabBarController + UITab |
| Tab(role: .search) | UISearchTab |
| ForEach(AppTab.allCases) | setupTabs()で個別生成 |
| .tabViewBottomAccessory | accessoryLabel（手動配置） |
| onScrollGeometryChange | scrollViewDidScroll |
| scrollPhase == .interacting | isDragging（beginDragging/endDragging） |
| .toolbarVisibility | tabBar.frame.origin.y操作 |
| .animation(.smooth) | UIView.animate(withDuration:) |

## iOS 18+ 新API

このプロジェクトで使ってるiOS 18以降のAPI。

SwiftUI側はTab(title:systemImage:)が新しいタブ構文、Tab(role: .search)が検索専用タブ、
.tabViewBottomAccessoryがタブバーの下にアクセサリViewを追加するやつ、
onScrollGeometryChangeがスクロール位置の変化を監視、
onScrollPhaseChangeがスクロール状態の変化を追跡、
ScrollPhaseがスクロール状態のenum（.idle / .interacting / .decelerating）。

UIKit側はUITabが新しいタブ定義API（viewControllersの代わりにtabsを使う）、
UISearchTabが検索専用タブ（Tab(role: .search)のUIKit版）。

iOS 17以下だとUITab / UISearchTabが使えないから、従来のviewControllers方式に戻す必要がある。
その場合タブのグループ分け（4+1）はできないけど見た目は同じ。

## SwiftUIとUIKitを両方書いてみた感想

同じものを両方で作ってみると、SwiftUIの便利さがよくわかる。

.tabViewBottomAccessoryが特に便利。
タブバーの下にテキスト置きたいだけなのに、UIKitだとview.addSubviewしてAutoLayoutの制約貼って、
タブバーが隠れたときの位置計算して、viewDidLayoutSubviewsでリセット対策して...とかなり手間がかかる。
SwiftUIは1行で終わる。

タブバーの表示/非表示も同じ。SwiftUIは.toolbarVisibility + .animationで完結する。
UIKitだとtabBar.frame.origin.yを手動で操作して、さらにUITabBarControllerが
レイアウトサイクルで位置をリセットしてくるからviewDidLayoutSubviewsで毎回再適用しないといけない。
これを知らないとアニメーションで動かしてもすぐ元に戻って意味がわからなくなる。

スクロール監視もSwiftUIはonScrollGeometryChange + onScrollPhaseChangeで宣言的に書ける。
UIKitだとscrollViewDidScroll、scrollViewWillBeginDragging、scrollViewDidEndDraggingの
3メソッドに分散して、isDraggingフラグを自分で管理する必要がある。

Tab(role: .search)とUISearchTabの対応も面白かった。SwiftUIだと1行で検索タブが別グループになるけど、
UIKitだとiOS 18+のUISearchTab APIを使わないと同じことができない。

逆にUIKitの方がいいところ、やっぱり
tableViewのセル再利用なんかはUIKitの方が細かく制御できる。
