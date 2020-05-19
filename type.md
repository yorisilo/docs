# 型
継承は悪

- [継承は害悪か。 - Togetter](https://togetter.com/li/86313)
- [オブジェクト思考: is-a関係とhas-a関係: 継承と包含](https://think-on-object.blogspot.com/2011/11/is-ahas-is-ahas-top-is-a-is-b.html)
- [Go 言語における「オブジェクト」 — プログラミング言語 Go | text.Baldanders.info](https://text.baldanders.info/golang/object-oriented-programming/#fnref:11)

golang には継承は無いけど、それが無いからと言って、いわゆる継承的なことができないわけではない。
埋め込みを使って、 interface を使えば、それっぽいことができる。

structural subtyping
- golang の interface を使ったやつとか。 typescript のやつとか
- golang の埋め込みは has-a っぽい

nominal subtyping
- java とかのいわゆる継承
- こっちの継承の問題点はいわゆるカプセル化の破れを誘発しやすいということ。サブクラスからスーパークラスの関数をオーバーライドするとか。

- is-a と has-a のちがい [3 クラス図を用いた設計](https://www.hakodate-ct.ac.jp/~tokai/tokai/doc2009/proen/cpp-3.html)
