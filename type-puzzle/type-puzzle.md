# 型パズル
- 型パズルとは: 型を使って様々な計算をすること。型を使って保守性を向上させるために使用されることが多い。

cf. ["型パズル"との付き合い方](https://talks.leko.jp/type-puzzle-world/#0)

# 値レベルではなく型レベルで足し算をやってみよう
- typescript version 4.4.3
- ここでお試しできます https://www.typescriptlang.org/play?#code/C4TwDgpgBAcghsAPDKEAewIDsAmBnKLAVwFsAjCAJwBooAlVDbfKOLEAbQF0oBeKbgD4+9DgCIANtgDmwABZie6TLgIoA-PSgAuWAmS0ObELQB05ul0EBuAFChIUAII4ciABqMVLYuSq0ATS9mAl8KSmF+DnNTeCR3QTNzOMQAwS5xKSxZBS47e3BoFxwAFRFixABGAGZaaurBWwBjAHssPGBWXWKy-gAWaqgAeiGoRH5AJANASIZAGIZAaIYgA

``` typescript
type Nat<N extends number, R extends any[] = []> = R["length"] extends N ? R : Nat<N, [any, ...R]>;
type Add<X extends number, Y extends number> = [...Nat<X>, ...Nat<Y>]["length"];

type AddT = Add<13, 33>
const a: AddT = 43 // <= 怒られる
```

- 数字をエンコード(表現)する方法としてはペアノの公理というもので定義するのが有名だが、今回は配列の長さを使って表現している。
- Nat: Nという数分だけ R にどんどん any を追加していっている。 なので、 N = 3 のとき、 [any, any, any] となる。
- Add: X, Y をもらって、 `Nat<X>` と `Nat<Y> `を作って、 それらを `...` で開いて大きな１つの配列にする。それの長さが足し算の結果である


# 細かく見てみる
## extends
- extends を `=` 右側で使うか左側で使うかで意味が変わる。
- 左側の extends は型の制約のために使用する。
- 右側の extends は型変数に対する条件分岐として使用する。 conditional types と呼ぶ

`type タイプ名<型変数 extends 制約,...> = 型変数 extends 条件 ? 真の型 : 偽の型`

> =より前のextendsと後のextendsで意味の異なることに注意が必要です。前者はタイプ利用時に間違った方が入った時点で文法エラーとなります。後者は条件によって返す方を分岐させる物です。
cf.[型地獄で戦うための定石メモ](https://zenn.dev/sora_kumo/articles/7e59942b952b27)

`R["length"] extends N ? R : Nat<N, [any, ...R]>` の意味

- 型を書くところではドットアクセスができないので`R.length` => `R["length"]`とする
- `R["length"]` が
  - N という数だったら R という配列を返す。
  - N という数じゃなかったら再帰を利用して、 Nat の R の配列に any を足す

# type challenges をやってみると楽しいよ
type challenges とは: 型パズル用の競プロみたいなやつ。オンライン上でいろいろな計算を型にやらせます。
ちまちまと型(盆栽)を育てましょう。

type chalenges では冒頭にこんなことが書いています。
> このプロジェクトは、型システムがどのように動作するのかを理解したり、独自の型ユーティリティを書いたり、課題へのチャレンジを楽しむことをサポートします。また、実際の業務で直面した問題を質問したり、その答えを得られるコミュニティを作りたいと考えています。 - そこでの問題が課題集に追加されるかもしれません！
- [type\-challenges/type\-challenges: Collection of TypeScript type challenges with online judge](https://github.com/type-challenges/type-challenges)

## keywords
- mapped type
- conditional type + infer
- 再帰型
- branding type
- type guard
...

# 実際に Add みたいな型を使用することはないが、、
type challenges を解くことで型パズルにアレルギー耐性が付いてくるのが一番のポイントだと思ってます。
typescript の組み込みの型関数を使うのもアレルギーがある人が多いと思うが、積極的に使うような思考が磨かれるのが良いポイント

## 例えば
以下のような型を用意して

``` typescript
type Ingredient = "chocolate" | "peanuts" | "cocoa" | "marshmallow" | "cherry";
```

それぞれの literal をプロパティとして持つ オブジェクト型を生成できたりする

``` typescript
export const ingredients: Record<Ingredient, string> = {
  chocolate: "Chocolate",
  cocoa: "Cocoa Powder",
  cherry: "Cherry",
  marshmallow: "Marshmallow",
  peanuts: "Peanut Butter",
};
```

`Record<K, T>`: K の literal union 型の１つずつがプロパティになり、それぞれ T を持つオブジェクト型になる。
