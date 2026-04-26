//
//  AttributeGraph.swift
//  AttributeGraphPlayground
//
//  Created by SHIRAISHI HIROYUKI on 2026/04/13.
//

/*
 このファイルなに

 SwiftUIの中で動いてるAttribute Graphってやつを自分で作ってみる勉強用。
 ただAppleのソースは非公開だから完全な答え合わせはできない!
 たぶんこうだろで推測して書いてる。

 登場人物
   AttributeGraph   グラフ全体の管理役
   Node<A>          頂点1個
   AnyNode          Nodeの型消去用

 ざっくり使い方

   ① グラフ作る
       let graph = AttributeGraph()

   ② 入力ノード（ただの値持ち）
       let a = graph.input(name: "A", 10)
       let b = graph.input(name: "B", 20)

   ③ ルールノード（他のノード見て計算するやつ）
       let c = graph.rule(name: "C") { a.wrappedValue + b.wrappedValue }

   ④ 値読む（ここで初めてrule走る）
       c.wrappedValue // 30

   ⑤ 入力変える（これは将来実装）
       a.wrappedValue = 40
       c.wrappedValue // 60 になるはず

 で、このファイルの設計の肝になってるのが「プルベース」ってやつ
 そもそもプルベースってなにかというと
 このファイルで言うとNodeのwrappedValueのgetがそれ

     var wrappedValue: A {
         get {
             if cachedValue == nil, let rule {
                 cachedValue = rule()   // ← ここが読まれて初めて計算してる
             }
             return cachedValue!
         }
     }

 読まれるまで何もしない。
 rule()は呼ばれるまで寝てる。
 こういうのをプルベース（pull-based）って言う
 「必要になったら引っ張ってくる」イメージ。

 逆はプッシュベースというのは入力が変わった瞬間に全部再計算しちゃうやつ。
 例えばa = 10, b = 20, c = a+bのときにa=40にした瞬間cも60に更新しに行く
 一見親切だけど、cが誰にも読まれなかったら計算のムダ

 SwiftUIがbodyを毎回全部走らせないのはプルベースだから
 画面に出てないViewのbodyは読まれない = 計算されない
 */


/// Attribute Graph内のノードを型消去するためのプロトコル
/// ジェネリックな Node<A> を配列で一括管理するために使用する
protocol AnyNode: AnyObject {

    /// グラフの可視化（Graphviz等）で使用するノードの識別名
    var name: String { get }
}



/*
 Node<A> について

 ノード1個 = グラフの頂点1個

 入力ノード
 ただの値持ち
 書き換えOK
 ruleはnil
 graph.input(name: "A", 10) で作る

 ルールノード
 クロージャで計算するやつ
 書き換えNG（assertで落ちる）
 graph.rule(name: "C") { a.wrappedValue + b.wrappedValue } みたいな

 wrappedValueどうなってんのかというと
 読むとき
 ①キャッシュあればそれ返す。
 ②なければrule()走らせてキャッシュに入れる。
 ③2回目以降はキャッシュから。

 ←これがさっき言ったプルベース。

 書くときは入力ノードだけ。
 ただルールノードに書いたらassertで死ぬ。
 要するにクラッシュさせて気づかせる作戦。
 */

/// Attribute Graph上の単一ノード
/// 入力値（input）またはルール（rule）のどちらかを持つ
/// ルールを持つ場合、他ノードへのアクセスが依存関係として記録される
final class Node<A>: AnyNode {

    /// グラフの可視化で使用するノードの識別名
    var name: String

    /// このノードの値を導出するルールクロージャ
    /// 入力ノードの場合は nil
    var rule: (() -> A)?

    /// ルールの評価結果または入力値をキャッシュするストレージ
    /// nil の場合、次回アクセス時にルールを実行して値を生成する
    private var cachedValue: A?

    /// ノードの現在値
    /// - get: キャッシュがなければルールを実行してキャッシュに保存する
    /// - set: 入力ノード専用ルールノードへの書き込みはアサーションで弾く
    var wrappedValue: A {
        get {
            if cachedValue == nil, let rule {
                cachedValue = rule()
            }
            return cachedValue!
        }
        set {
            assert(rule == nil, "ルールノードへの直接書き込みは禁止")
            cachedValue = newValue
        }
    }

    // MARK: - 初期化

    /// 入力ノードを生成する
    /// - Parameters:
    ///   - name: グラフ上での識別名
    ///   - wrappedValue: ノードの初期値
    init(name: String, wrappedValue: A) {
        self.name = name
        self.cachedValue = wrappedValue
    }

    /// ルールノードを生成する
    /// - Parameters:
    ///   - name: グラフ上での識別名
    ///   - rule: 値を導出するクロージャ他ノードへのアクセスで依存関係が記録される
    init(name: String, rule: @escaping () -> A) {
        self.name = name
        self.rule = rule
    }
}

/// ノードと依存関係（エッジ）を管理するグラフ本体
/// 入力の変更を検知し、依存するノードをダーティとしてマークして遅延再評価を行う
final class AttributeGraph {

    init() {
        print("AttributeGraphが作られた")
    }

    /// グラフに登録されている全ノード型消去済み
    var nodes: [AnyNode] = []

    /// 固定値を持つ入力ノードを生成してグラフに追加する
    /// - Parameters:
    ///   - name: グラフ上での識別名
    ///   - value: ノードの初期値
    /// - Returns: 生成した入力ノード
    func input<A>(name: String, _ value: A) -> Node<A> {
        print("input(\(name))が呼ばれた")
        let n = Node(name: name, wrappedValue: value)
        nodes.append(n)
        return n
    }

    /// ルールクロージャを持つノードを生成してグラフに追加する
    /// クロージャ内で他ノードの wrappedValue にアクセスすることで依存関係が自動登録される
    /// - Parameters:
    ///   - name: グラフ上での識別名
    ///   - rule: 値を導出するクロージャ
    /// - Returns: 生成したルールノード
    func rule<A>(name: String, _ rule: @escaping () -> A) -> Node<A> {
        print(" rule(\(name))が呼ばれた")
        let n = Node(name: name, rule: rule)
        nodes.append(n)
        print(" rule(\(name))からreturnする")
        return n
    }
}
