2019-08-25 14:58:40

# 再帰関数の効率的な書き方
* 末尾再帰の実装方法(アキュムレータを使うver 継続を使うver)

# 目次
* for 文 :-1: -> 再帰関数 :+1:
* なぜ普通の再帰よりも末尾再帰が(計算効率的に)良いのか
* 再帰でも、いわゆる break とか continue を表現することができるよ
* 末尾再帰(アキュムレータver)を書く際のコツ (for 文で関数を書くときを思い浮かべると良い)
* (末尾再帰(cps ver))
* 末尾再帰のメリット

* golang では末尾再帰最適化できるか
  * アセンブリを見てみる

# ハンズオンの環境
扱う言語は何でもいいのですが、今回は haskell と golang で説明していきます。

- haskell のオンライン実行環境: https://paiza.io/projects/UaK7d0V4vlEaPBS-UaSRlw?locale=ja-jp
- golang のオンライン実行環境: https://play.golang.org/

# 末尾再帰
## for 文 :-1: -> 再帰関数 :+1:
> 多くの言語では、素朴な繰り返しを実現するためには for 文や while 文を使います。
> for文を単純に数え上げとして使う場合、カウンターである変数 i が再代入できるとことが前提になっています。
> Haskell では、変数に再代入はできません。それは、for 文がないことを意味します。どうやって、繰り返しを実現するのでしょうか？ その答えは、再帰です。
cf. [Haskellの文法\(再帰編\) \- あどけない話](https://kazu-yamamoto.hatenablog.jp/entry/20110829/1314584585)

再帰関数では、
- 再代入を行う必要が無くなる(参照透過性を担保し副作用の排除に一役買っている)
- 複雑なアルゴリズムを少ないコードで表現できる。漸化式などを直接エンコードしやすい
- 無限の構造をコードに落とすことが容易 -> 具体例: http://wosugi.hatenablog.com/entry/20090721/1249097807

## なぜ普通の再帰よりも末尾再帰が(計算効率的に)良いのか
* 再帰は普通に書くとスタックをたくさん消費してしまう。コールスタックを消費することによるスタックオーバーフローやメモリ不足を引き起こしてしまう可能性がある

* 末尾再帰で書くと再帰の部分は単なるジャンプとなりスタックを消費しない。
（正確には「末尾呼び出しは容易にジャンプに変換できる。末尾再帰は末尾呼び出しの対象が自身になっているという特殊ケースであり、ループに変換できる」）
> 再帰関数はwhileのようなジャンプ制御ではなく、関数内部で自分自身を再帰的に呼び出すことでループを表現します。その特性上、自分自身を大量に呼び出す必要があるケースが少なくありません。再帰呼び出しでもコールスタックを積んでいくので、メモリを消費してしまいスタックオーバーフローやメモリ不足に陥ることがあります。
> 再帰関数を、末尾再帰と呼ばれる再帰パターンで記述することで、言語によっては最適化を行えます。この最適化によって、コールスタックを消費する関数呼び出しではなく、ジャンプ制御に変換されます。ジャンプ制御に変換されることで、処理が高速になったり、スタックオーバーフローやメモリ不足に陥ることを防ぐことができます。
cf. [Haskellの文法\(再帰編\) \- あどけない話](https://kazu-yamamoto.hatenablog.jp/entry/20110829/1314584585)

例:

haskell
``` haskell
fact :: Int -> Int
fact 0 = 1
fact n = n * (fact $ n - 1)
```

golang
``` golang
func fact(n int) int {
	if n == 0 {
		return 1
	}
	return n * fact(n-1)
}
```

実行過程
どんどんスタックに積まれていくのが見て分かる。

```
fact 4
↓
4 * (fact 3)
↓
4 * (3 * (fact 2))
↓
4 * (3 * (2 * (fact 1)))
↓
4 * (3 * (2 * (1 * (fact 0))))
↓
4 * (3 * (2 * (1 * (1))))
↓
4 * (3 * (2 * (1)))
↓
4 * (3 * (2))
↓
4 * (6)
↓
24
```

このプログラムは再帰の度にスタックを使っています。
つまり、fact 3 をやっている中で fact 2 を呼び出すとき、
「fact 2 の答えが求まった後には 3 * [] をやる」ということを
スタックを使って覚えているわけです。

これを、スタックを使わないように書き換えることができます。

この問題は、末尾再帰を使うと解決します。
末尾再帰とは、= の横に、値か、自分自身のみが現れる形の再帰です。末尾再帰に書き換える常套手段は、引数を一つ追加することです。
その引数のことをアキュムレータと呼びます

末尾再帰 アキュムレータver
haskell

``` haskell
fact :: Int -> Int -> Int
fact 0 acc = acc
fact n acc = fact (n - 1) (n * acc)

-- acc を使った末尾再帰関数を隠匿する方法
fact :: Int -> Int
fact n = fact' n 1
    where
        fact' 0 y = y
        fact' x y = fact' (x - 1) (x * y)
```

golang
``` golang
func fact1(n, acc int) int {
	if n == 0 {
		return acc
	}

	return fact1(n-1, n*acc)
}
```

実行過程
処理数も少なく、一度出てきた計算はその時に終わらせているのでスタックを消費しない

``` haskell
fact 4 1
↓
fact 3 4
↓
fact 2 12
↓
fact 1 24
↓
fact 0 24
↓
24
```

このように、関数を呼び出した後に(スタックが)覚えておかなくてはならない作業がないような関数呼び出しのことを「末尾呼び出し(tail call)」と言います。(関数呼び出しのときに自分自身を呼び出すか、定数を呼ぶか)
再帰呼び出しが末尾呼び出しになっている場合、それを末尾再帰(tail recursion)と呼びます。

## 再帰でも break とか continue とか表現できるよ
### break
例として、配列の中に -1 を発見したら足し算を止め、それまでに計算した和を返す関数を考えます。

``` go
func sum1(xs []int) int {
	sum := 0

	for i := 0; i < len(xs); i++ {
		if xs[i] == -1 {
			break
		}
		sum = sum + xs[i]
	}
	return sum
}
```

haskell
``` haskell
-- 普通の再帰での break
sum1 :: [Int] -> Int
sum1 [] = 0
sum1 x:xs
     | x == -1 = sum1 [] -- break に相当
     | otherwise = x + sum1 xs

-- acc を使った break
sum1 :: [Int] -> Int -> Int
sum1 []     acc = acc
sum1 (x:xs) acc
      | y == -1   = acc -- ここが break に相当する break の目的はその時点での計算結果を返せば良いのでそれを返せばおｋ
      | otherwise = sum1 xs (x + acc)

-- acc を使った末尾再帰関数を隠匿する方法
sum1 :: [Int] -> Int
sum1 xs = f xs 0
  where
    f []     s = s
    f (y:ys) s
      | y == -1   = s -- ここが break に相当する
      | otherwise = f ys (y + s)
```

### continue
continue の例もみてみましょう。
例として負の数を排除して、0以上の数を足し合わせる関数を考えます。


``` go
func sum2(xs []int) int {
	sum := 0

	for i := 0; i < len(xs); i++ {
		if xs[i] < 0 {
			continue
		}
		sum = sum + xs[i]
	}
	return sum
}
```

``` haskell
-- 普通の再帰での continue
sum2 :: [Int] -> Int
sum2 [] = 0
sum2 x:xs =
     | x < 0     = sum1 xs -- continue に相当
     | otherwise = x + sum1 xs

-- acc を使った continue
sum2 :: [Int] -> Int -> Int
sum2 []     acc = acc
sum2 (x:xs) acc
     | x < 0     = sum2 xs acc -- ここが contiune に相当する。 x < 0 は無視して次の候補へ再帰を進めればおｋ
     | otherwise = sum2 xs (x + acc)

-- acc を使った末尾再帰関数を隠匿する方法
sum2 :: [Int] -> Int
sum2 xs = f xs 0
  where
    f []     s = s
    f (y:ys) s
      | y < 0     = f ys s -- ここが contiune に相当する
      | otherwise = f ys (y + s)
```

### 閑話休題：節度を知る
> 変な話なのですが、再帰をよく理解したら、なるべく(陽に)再帰を使ってはいけません。上記の例を見ると再帰が goto 文のように思えた人がいるかもしれませんが、その直観はあたっています。再帰はいろんなことが実現できるので、読み手には理解しずらいのです。
> 熟達した Haskeller は、以下のような力の階層を理解しています。
> * 再帰
> * foldr、foldl など
> * filter、take など
>
> 上が力が強く、下へ行くほど力が弱くなります。力が強いと何でもできてしまうので、コードの意図が不明瞭となり、また間違いが入り込みやすくなります。力が弱いとできることは限られるのでコードの意図は明確となり、間違いが入りにくくなります。
>
> 「目的に合う一番力の弱い手段を使う」のがよいプログラムを書くための大原則です。たとえば、草を刈るのにチェーンソーは使うべきではありません。もちろん草も切れますが、大切な植木も傷つけてしまうかもしれませんから。
>
> これまでのコードは、再帰を(陽に)使わなくとも、以下のように実現できます。

``` haskell
sum0 = foldr (+) 0
sum1 = sum0 . takeWhile (/= -1) -- takeWhile は break に使える
sum2 = sum0 . filter (>=0) -- filter は continue に使える
```

cf. foldr について: http://succzero.hatenablog.com/entry/2013/12/07/234808

> 再帰を(陽に)使わなければ、こんなに意味が分かりやすくなるのです。なお、foldr や takeWhile 自体は再帰を使って実装されています
また、そのようなプリミティブを使うことで普通に自分で再帰関数を使うよりも実行速度も速くや実行効率の良いプログラムになりやすい。

## 末尾再帰 アキュムレータver を書くときのコツ
処理系が対応していれば末尾再帰最適化は大体ループに変換している。
それと逆のことを頭でやればおｋ

階乗関数を手続き的に書くとこう

``` go
func fact(n int) int {
	sum := 1

	for i := n; i > 0; i-- {
		sum = sum * i
	}

	return sum
}
```

この手続き的な関数には

* カウンタ -> i
* 演算に必要な値 -> i
* 計算結果 -> sum

がある

末尾再帰するときはこれをトップレベルの引数の中で行えばよい。

階乗関数 末尾再帰 acc ver 再掲

``` haskell
fact :: Int -> Int -> Int
fact 0 acc = acc
fact n acc = fact (n - 1) (acc * n)
```

* カウンタ -> n
* 演算に必要な値 -> n
* 計算結果 -> acc


### 累乗
`x^a`

``` golang
func pow(x, a int) int {
	sum := 1
	for i := a; i > 0; i-- {
		sum = x * sum
	}
	return sum
}
```

* カウンタ -> i
* 演算に必要な値 -> x
* 計算結果 -> acc

``` haskell
pow :: Int -> Int -> Int -> Int
pow x 0 acc = acc
pow x a acc = pow x (a - 1) (x * acc)
```

### Fibonacci
次は普通のダイレクトスタイルの再帰関数からaccを使った末尾再帰に変換してみる

f(n) = 1 if n == 0 or n == 1
f(n) = f(n-2) + f(n-1)

``` haskell
fib :: Int -> Int -> Int -> Int
fib n x acc
  | n == 0    = 1
  | n == 1    = acc
  | otherwise = fib (n-1) acc (x + acc)
```

* カウンタ -> n
* 演算に必要な値 -> x
* 計算結果 -> acc

実行過程
```
fib 5 1 1
↓
fib 4 1 2
↓
fib 3 2 3
↓
fib 2 3 5
↓
fib 1 5 8
↓
8
```

cf.
* [もしかしたら末尾再帰って簡単なんじゃないか？という話 #Haskell - Qiita](https://qiita.com/Tatsuki-I/items/9f416dc4edbb9161c780)

## 末尾再帰 継続渡しスタイル cps ver
- ダイレクトスタイルの再帰関数から末尾再帰関数に変換することで関数呼び出しの順番が変わってしまう。

ダイレクトスタイル再帰
``` haskell
fact :: Int -> Int
fact 0 = 1
fact n = n * fact(n-1)
```

実行過程
```
fact 3
↓
3 * (fact 2)
↓
3 * (2 fact 1)
↓
3 * (2 * (1 fact 0))
↓
3 * (2 * (1 * (1)))
...
```

末尾再帰 acc ver
``` haskell
fact :: Int -> Int -> Int
fact 0 acc = acc
fact n acc = fact (n - 1) (acc * n)
```

```
fact 3 1
↓
fact 2 (3 * 1)
↓
fact 1 (3 * 2)
↓
fact 0 (6 * 1)
↓
6
```

ここで、上の末尾再帰の例で階乗の計算はどのように行われているか
少し見直してみましょう。
末尾再帰に変換する前は
    `3 * (2 * (1 * 1))`
のようにかけ算をしていましたが、末尾再帰に変換したものでは
    `((3 * 1) * 2 ) * 1`
のようにかけ算が行われます。
変換後は、かけ算をする順序が変わってしまっています。
かけ算では順序が変わってもそう問題は起こりませんが、
順序が変わると困る場合もあります。

例として、リスト中の順番は変えないで正の要素のみを取り出す関数 positive を考えます。

``` haskell
positive :: [Int] -> [Int]
positive []   = []
positive x:xs =
  | x > 0     = x : (positive xs)
  | otherwise = positive xs
```

アキュムレータを使って無理やり書いてみる

``` haskell
positive :: [Int] -> [Int] -> [Int]
positive []   acc = acc
positive x:xs acc =
  | x > 0     = positive xs (acc ++ [x])
--| x > 0     = positive xs (x:acc) だと [1,2,3] ~> [3,2,1] のように順番が変わってしまう
  | otherwise = positive xs
```

リストの最後にくっつけるには、リストの長さに比例した時間がかかるので、（小さなプログラムでは気にならないかもしれませんが、）ちょっと避けたい事態です。

処理の順序を変えることなく末尾呼び出しの形にプログラムを書き換えるには、
アキュムレータを使うのではなく、次のようにします。

``` haskell
positive :: [Int] -> ([Int] -> [Int]) -> [Int]
positive [] cont = cont []
positive (x : xs) cont
  | x > 0 = positive xs (\acc -> cont (x : acc))
  | otherwise = positive xs cont
```

ここで cont は「継続(continuation)」と呼ばれます。
直観的には、「その計算が終わったあとにする計算」を表します。
上の関数を次のように呼び出したとすると、以下のように実行されていきます。
（ここで、id とは恒等関数で、具体的には `\x -> x` とします。）

実行過程

```
positive [1, -2, 4, 3] id
↓
positive [-2, 4, 3] (\acc -> id (1 : acc))
↓
positive [4, 3] (\acc -> id (1 : acc))
↓
positive [3] (\acc -> (\ acc -> id (1 : acc)) (4 : acc))
= positive [3] (\acc -> id (1 : 4 : acc))
↓
positive [] (\acc -> (\ acc -> id (1 : 4 : acc)) (3 : acc))
= positive [] (\acc -> id (1 : 4 : 3 : acc))
↓
(\ acc -> id (1 : 4 : 3 : acc)) []
↓
id (1 : 4 : 3 : [])
↓
1 : 4 : 3 : []
↓
[1, 4, 3]
```

ちなみに、上の実行例で = で結ばれているところは、わかりやすくするために簡略化しましたが、call-by-value の実行では実際には簡略化されません。

### 閑話休題: 評価戦略について
評価戦略(引数の呼び出し方)には以下のように色々とあるので調べてるみると面白いと思います。

正格評価: 関数の引数が常にその関数に引き渡される前に完全に評価される
- call-by-value: 大体の言語はこれが使われてる
...

遅延評価(正格でない評価): 関数の引数は関数本体の評価で実際に使われるまで評価されない。
- call-by-name
- call-by-need: call-by-name をメモ化したようなやつ。 haskell とかで使われてる
...

### fact 関数を CPS で書いてみる

``` haskell
fact :: Int -> (Int -> Int) -> Int
fact 0 cont = cont 1
fact n cont = fact (n-1) (\x -> cont(n*x))
```

実行過程

```
fact 4 id
↓
fact 3 (\x -> id(4 * x))
↓
fact 2 (\x -> ((\x -> id(4 * x))(3 * x)))
↓
fact 1 (\x -> (((\x -> id(4 * x))(3 * x))(2 * x)))
↓
fact 0 (\x -> ((((\x -> id(4 * x))(3 * x))(2 * x))(1 * x)))
↓
(\x -> ((((\x -> id(4 * x))(3 * x))(2 * x))(1 * x))) 1
↓...
4 * (3 * (2 * (1)))
↓
24
```

### n 番目のフィボナッチ数列を計算する末尾再帰 cps ver を書いてみましょう！

ダイレクトスタイル
``` haskell
fib :: Int -> Int
fib n
  | n == 0 || n == 1 = 1
  | otherwise = fib (n - 1) + fib (n - 2)
```

<details>
<summary>cps ver</summary>

```

```

</details>


cf.
* [末尾呼び出し(tail call)と継続渡し形式(Continuation Passing Style): Asai Laboratory, Ochanomizu University](http://pllab.is.ocha.ac.jp/zemi_2.html)
* [Haskell で継続渡しスタイル (CPS) | すぐに忘れる脳みそのためのメモ](https://jutememo.blogspot.com/2011/05/haskell-cps.html)

## 末尾再帰のメリット
末尾再帰にするメリットは、スタックに覚えておかなくてはならないような
情報がないのでスタックが不要になることに加え、コンパイラが
プログラムを関数呼び出しとしてではなくループとしてコンパイル
するので高速になるということです。

また、自由に計算を中断できるということもあげられます。
例えば、階乗のプログラムを末尾呼び出しで書いておけば、
fac 1 6 まできたところで一時中断して、別のことをしてから、
後でまた計算を再会する……といったことが簡単にできます。
システムのスタックを使っていたら、計算の中断/再開に伴って
システムのスタックも退避/復活しなくてはなりません。

関数を末尾再帰にする方法がいくつか存在する

* 上記のように アキュムレータを使う方法(計算結果を引数として渡す)
* 継続渡し(CPS)
* トランポリン形式
... など。 トランポリン形式は実装もしたことないしよく知らない…

継続を渡すことで全ての関数呼び出しを末尾呼び出しの形で書いた
プログラムのことを継続渡し形式(CPS : Continuation Passing Style)で
書かれたプログラムと呼びます。これと対比して、CPS でない通常のプログラム
のことを直接形式 direct style と言ったりもします。

## 末尾再帰最適化って何してるのか
処理系によるが関数呼び出しをループに変換してる

* 関数呼び出し自体のパフォーマンス
* コールスタックの最適化
  * (再帰の場合、スタック領域の初期化、パラメーターの引渡し（値渡しならコピーが必要）、関数へのジャンプ、関数からのリターン処理、が必要ですが、ループにはこれらが必要ない)

が再帰関数のパフォーマンスに寄与してくるので、再帰関数を書くときは極力末尾再帰したほうが良い(処理系によっては末尾再帰最適化が効かないのでそもそも再帰関数を書かないほうが良いこともある…)

## golang で末尾再帰最適化ができるか
- 結論： golang ではできない

> 関数呼び出し自体はgoroutineの管理などもあり、そもそもがgoroutineを大量に呼べるようにスタックサイズがデフォルトで小さく設定されていて、かつ自動で管理するようにランタイムで調整が入る。
> Goではスタックトレースで表示されることが大事なので、敢えて最適化していないという状況なので仕方ないかなと思います。
* [Tail call optimization - Google グループ](https://groups.google.com/forum/#!msg/golang-nuts/nOS2FEiIAaM/miAg83qEn-AJ)

``` shell
# アセンブリコードの出力
go build -gcflags -S main.go
```

cf.
* [Goで再帰使うと遅くなりますがそれが何だ - YAMAGUCHI::weblog](https://ymotongpoo.hatenablog.com/entry/2015/02/23/165341)
* [goで末尾再帰最適化は使えるか？](https://www.slideshare.net/moritakuma1/go-77362467)

## 参考文献
* [Haskellの文法(再帰編) - あどけない話](https://kazu-yamamoto.hatenablog.jp/entry/20110829/1314584585)
* [Haskell コード片鑑賞：「再帰」編 - Qiita](https://qiita.com/nobsun/items/6c2fa63f294dbd98d5cb)
* [もしかしたら末尾再帰って簡単なんじゃないか？という話 #Haskell - Qiita](https://qiita.com/Tatsuki-I/items/9f416dc4edbb9161c780)
* [Scalaではじめる末尾再帰 - Qiita](https://qiita.com/dashiishida/items/c20d6e08a260e3ce0f64)
* [「末尾呼び出し(tail call)と継続渡し形式(Continuation Passing Style)」 Asai Laboratory, Ochanomizu University](http://pllab.is.ocha.ac.jp/zemi_2.html)

# appendix
## ラムダ計算
- チャーチの提唱(チャーチ チューリングの提唱): チューリングマシンで表現できるプログラム = ラムダ項で表現できる関数の集合 = コンピュータで計算可能な関数の集合 = 再帰関数のクラス(Rクラス？)

## (複雑性)クラス
計算量理論などなど色んな所で使われるクラスについて

- P: 多項式時間のアルゴリズムがある問題。 大雑把に言うなら早く計算できる問題
- NP: 解の検証が多項式時間でできる問題のクラス
- NP完全: 解の検証は多項式時間でできるが、解を求める多項式時間アルゴリズムは今のところ知られていないもの
- NP困難: 非形式的に言うとNPに属する任意の関数と比べて同等以上に難しい問題
- 決定不可能: 計算可能じゃないクラス

- NP完全問題の例: 最大クリーク、 最大独立点集合、3SAT、 2分割、点彩色、etc...
- P問題の例: 極大クリーク、 最大マッチング、2SAT、
- 決定不能問題の例: 停止問題

cf. https://blog.tiqwab.com/2017/03/09/computable-function.html

## 再帰をループに展開

cf.
* [Goto は必要か？ 「再帰をループに展開」篇 - ksmakotoのhatenadiary](https://ksmakoto.hatenadiary.com/entry/2013/08/03/222613)
