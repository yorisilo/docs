# フロントエンド JavaScript/TypeScript
# JavaScript
ECMAScript によって、仕様規定された言語

ランタイムによって、言語の実装が異なる。
- ブラウザ
- Nodejs
- Deno など

シンタックスはほぼ同じなんだけど、実際にどう動くかはランタイム依存
基本的にそれぞれのランタイムはシングルスレッドで動くように実装されているので、並列処理はできないのだが、 ランタイム(実行環境)によって、非同期処理を実現している。

<details>
<summary>ランタイム</summary>

実行環境と呼ばれたりする
コードを解釈し処理を実行するためのもろもろ

</details>

<details>
<summary>js はなぜシングルスレッドで動くような仕様になっているか</summary>

JavaScript がシングルスレッドで動作するのは、元々はブラウザ上で動作するための言語であり、ブラウザがマルチスレッドでなくシングルスレッドであることに起因している。

ブラウザは、UI のレンダリングや JavaScript 実行環境を単一のスレッドで動作する。複数のスレッドを使用すると、DOM へのアクセスや他のブラウザイベントの処理に関する同期化の問題が生じ、それがパフォーマンスや安定性に悪影響を与える可能性がある。

JavaScript がシングルスレッドであることは、開発者がコードをより簡単に理解できるようにする一方、非同期処理が必要な場合にコードを設計する際の課題も生み出した。非同期処理を実行するには、コールバック、Promise、async/await などの手法が使用される。これらは、JavaScript がシングルスレッドであることによって引き起こされる問題に対処するための手段となっている。

</details>

# 非同期処理をどのように実現しているか
JavaScript のランタイムは基本的にシングルスレッドで一度に実行できるタスクは1つだけであるが、JavaScript の各種ランタイム(ブラウザとか Node とか Deno とか)ではイベントループを実装しており、非同期で処理を行う仕組みが導入されている。
JavaScript はブラウザのメインスレッドで実行されるので、30秒かかるタスクを実行すると、その時間はブラウザが動かなくなる。
なので、イベントループの仕組みを使った非同期処理を頻繁に使用することになる。
よくある Ajax(非同期的にサーバーと通信するための手段の一つ) 関係の処理はほぼ100%が非同期処理である。

<details>
<summary>Ajax 処理の例</summary>

最近はブラウザの WEB API に fetch API が導入されたので、 fetch API がよく使われるようになっている。

上から順に新しい
- fetch API
- axios
- jQueryの$.ajax()
- XMLHttpRequest

fetch() 関数は、2015年に発行された ECMAScript 2015(ES6)で導入された。
それ以前は、WebページからサーバーにHTTPリクエストを送信するには、一般的に XMLHttpRequest オブジェクトを使用していた。しかし、fetch() 関数はより簡潔で直感的なAPIを提供するために開発されており、 Promise ベースの非同期処理にも対応している。

</details>

## なぜシングルスレッドなのに、非同期処理が実現できるのか
実は JavaScript は多くの処理を実行環境で提供されている API に任せている。

> 私たちがjsだと思っているものはjsの言語規格(ECMAScript)の守備範囲に、実行環境が提供するAPIを組み合わせたものだといえる [Some Javascript features are actually Browser APIs \- Dillion's Blog](https://dillionmegida.com/p/browser-apis-and-javascript/)

例えば、setTimeout() や setInterval() を担う Timers の spec は ECMAScript にはなく、ブラウザがそれらを実装している。
また、 fetch API の実装もブラウザが行っている。

## もうちょっと詳しく
イベントループというしくみによって非同期処理をいい感じにこなしている。
イベントループ: 実行環境(ブラウザ、Nodejs, Deno...) において、処理すべき色々なこと(jsの処理やブラウザだとレンダリング等諸々含む)を整理して、実行してくれるやつ。

ブラウザ上で JavaScript が非同期処理を実現するためには、以下の 4 つの要素が重要である。

- イベントループ
- Web API
- タスクキュー
- マイクロタスクキュー

### イベントループ
イベントループは、JavaScript の非同期処理の中心的な仕組みである。JavaScript のコードは、1つのスレッドで実行されるため、一度に1つのタスクしか実行できない。
しかし、非同期処理によって処理がブロックされないようにするために、イベントループが使用される。
イベントループの役割は、タスクキューとマイクロタスクキューにキューイングされたタスクを管理し、優先度を付けてコールスタックへ追加し、それらを順次実行することである。

すごく簡単な実行の順序の説明
- js を評価し、
- マイクロタスクキューを実行し
- タスクキューを実行し
- レンダリングする

### Web API(ブラウザ内)
[Web API \| MDN](https://developer.mozilla.org/ja/docs/Web/API) は、JavaScript から利用できるブラウザの非同期機能を提供するためのAPIである。Web API には、setTimeout、setInterval、XMLHttpRequest、fetch などが含まれる。
これらの機能は、イベントループにタスクを追加し、非同期的に実行される。

例えば、以下のコードは、2秒経ったらタスクキューに `alert('Hello, World!')` を追加する。
setTimeout 関数は、指定された時間が経過した後に callback をタスクキューに追加するものであり、 指定された時間が経過した後に処理を実行するものではないので注意

``` javascript
setTimeout(function() {
  alert('Hello, World!');
}, 2000);
```

Promise を返さないから、この関数は同期処理！みたいなことではないので注意すること。
setTimeout は Promise を返さないが、非同期処理である。
このように Promise を返さない関数やメソッドが非同期処理であることを知るためにはどうすればいいのだろうか。
一般的には、ドキュメントをよく読み、関数やメソッドがどのように動作するかを理解し、それが非同期的に動作するかどうかを確認することが重要である。

たとえば以下のようなものは非同期処理であることがよくあるので、 Promise に包まれてない場合は包んでから使ってやると扱いやすい。
- コールバック関数を利用した関数/メソッド: 関数の引数としてコールバック関数を指定することができる場合、処理が非同期であることが示されることがある。
- イベントリスナー: DOM イベントリスナーに関連するメソッドは、通常、非同期的に動作することが期待されている。
- タイマー: setTimeout や setInterval は非同期処理を行うため、処理が完了するまでに時間がかかることを示している。

<details>
<summary>setTimeout を Promise に包む</summary>

``` javascript
const delay = (ms) => {
  return new Promise(resolve => setTimeout(resolve, ms));
}

delay(1000).then(() => {
  console.log('1秒後に実行された！');
});

// or

await delay(1000);
console.log('1秒後に実行された！');
```

</details>


<details>
<summary>非同期的な処理をする関数なのに Promise を返さないライブラリがあるのはなぜか</summary>

Promise 以前に登場したライブラリやフレームワークは、非同期処理を実現するためにコールバック関数を使っていたため、それらを Promise に変更することはコードの大幅な変更が必要で、リスクも大きいため、現実的ではないから。
そのため、現在でも一部の非同期的な関数で Promise を返さない実装が存在している。しかし、新しいコードでは可能な限り Promise を使うことが推奨されている。
また、既存の非同期的な関数で Promise を返さない場合は、その関数を Promise を返すようにラップすることで、コールバック関数を使うことなく、Promise を扱うことができる。

</details>


### タスクキュー(マクロタスクキュー)
タスクキューには、Web API によって非同期的にコールバック関数が追加される。

### マイクロタスクキュー
マイクロタスクキューは、プロミスのコールバック(Promise.then で渡すやつとか)、 Promise.resolve() や Promise.reject() を呼び出すことで追加されるコールバックのキューである。
タスクキューより、マイクロタスクキューのほうがコールスタックへ追加される優先度が高い

### 具体例

``` javascript
console.log('start');

setTimeout(() => {
  console.log('setTimeout');
}, 0);

Promise.resolve().then(() => {
  console.log('Promise resolve');
});

console.log('end');
```

このコードでは、setTimeoutで登録したコールバック関数と、Promise.resolve().then()で登録したコールバック関数が非同期で実行される。setTimeoutで登録したコールバック関数は、タスクキューに追加され、Promise.resolve().then()で登録したコールバック関数は、マイクロタスクキューに追加される。実行順序は以下のようになる


<details>
<summary>実行順序</summary>

``` javascript
start
end
Promise resolve
setTimeout
```

</details>

このように、イベントループとWEB API、そしてタスクキューとマイクロタスクキューおよびコールスタックが組み合わさることで、非同期処理が実現される。

## アニメーションでわかりやすく
- [✨♻️ JavaScript Visualized: Event Loop \- DEV Community 👩‍💻👨‍💻](https://dev.to/lydiahallie/javascript-visualized-event-loop-3dif)

## もっともっと詳しく
- [jsが非同期処理をシングルスレッドで実現する仕組み〜Web API、イベントループ、MicrotaskとしてのPromise〜](https://zenn.dev/canalun/articles/js_async_and_company)
- [Node\.jsでのイベントループの仕組みとタイマーについて \- hiroppy's site](https://hiroppy.me/blog/nodejs-event-loop)
- [それぞれのイベントループ｜イベントループとプロミスチェーンで学ぶJavaScriptの非同期処理](https://zenn.dev/estra/books/js-async-promise-chain-event-loop/viewer/c-epasync-what-event-loop)

# 非同期処理と同期処理の扱いの歴史
## callback hell
getData や getMoreData が非同期関数の場合、このようにコールバック関数を入れ子にして、同期的な処理を実現していた。
このようなコールバック関数がネストしまくる状態を callback hell と呼ぶ。

``` javascript
getData(function(data1) {
  getMoreData(data1, function(data2) {
    getMoreData(data2, function(data3) {
      getMoreData(data3, function(data4) {
        // さらに多くの処理
      });
    });
  });
});
```

## promise then
この問題を解決するため ECMAScript2015 にて、 Promise が導入された。
Promiseは、非同期処理が完了したときにresolve関数を呼び出すことで成功した結果を返し、reject関数を呼び出すことで失敗した結果を返す。これにより、 callback hell を回避することができる。


<details>
<summary> getData, getMoreData の例</summary>

``` javascript
const getData = async () => {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve('data1');
    }, 1000);
  });
};

const getMoreData = () => {
  let index = 2;
  return async (data) => {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(`${data} data${index++}`);
      }, 1000);
    });
  };
};
```

</details>


``` javascript
getData()
  .then(function(data1) {
    return getMoreData(data1);
  })
  .then(function(data2) {
    return getMoreData(data2);
  })
  .then(function(data3) {
    return getMoreData(data3);
  })
  .then(function(data4) {
    // さらに多くの処理
    console.log(data4);
  });
```


<details>
<summary>Promise</summary>

### Promise

``` javascript
new Promise((resolve, reject) => {
  // 同期処理
}).then(() => {
  // resolveの実行を待って非同期処理
}).catch(() => {}
  // rejectの実行を待って非同期処理
}).finally({
  // resolveかrejectの実行を待って非同期処理
});
```

``` javascript
const promise = new Promise((resolve, reject) => {
  console.log("Promise start");
  if (Math.random() < 0.5) {
    return resolve("😁 true なので履行する");
  } else {
    return reject("😭 false なので拒否する");
  }
  console.log("👻 関数は止まらない");
});

promise
  .then((value) => console.log("🍓 履行値:", value))
  .catch((reason) => console.error("🥦 拒否理由:", reason))
  .finally(() => console.log("👍 チェーン最後に実行"));
```

### 詳しく
- [【JavaScript】非同期処理（コールスタック、キュー、Promise、async/await）について図解で理解する。 \- Qiita](https://qiita.com/sho_U/items/f07a4f3e7760a9729f10)
- [resolve 関数と reject 関数の使い方｜イベントループとプロミスチェーンで学ぶJavaScriptの非同期処理](https://zenn.dev/estra/books/js-async-promise-chain-event-loop/viewer/g-epasync-resolve-reject)

</details>

## async await
また、 ECMAScript 2017(ES2017) で async/await が導入された。async/awaitは、Promiseをより簡潔に書くことができる構文で、非同期処理を同期的に書くことができる。async 関数の中で await を使うことで、 Promise の処理が完了するまで待機することができる。 ちなみに ES2022 では top level await が導入された。

ES2022 ver
``` javascript
const data1 = await getData();
const data2 = await getMoreData(data1);
const data3 = await getMoreData(data2);
const data4 = await getMoreData(data3);
...
```

# TypeScript
JavaScript と型システムを合体させたもの
TypeScript は JavaScript のスーパーセットなので、 JavaScript のコードは基本的にそのままで動く。

## 型で遊ぼう
TypeScript の型はチューリング完全
型レベルで足し算とかできたりする。

cf. https://github.com/yorisilo/docs/blob/master/type-puzzle/type-puzzle.md

## nominal typing(公称型) と strucctural subtyping(構造的部分型)
基本的に TypeScript の型システムは strucctural subtyping(構造的部分型) を採用している。

``` typescript
type USD = number;
type EUR = number;

const usd: USD = 10;
const eur: EUR = 10;

const gross = (net: USD, tax: USD): USD => {
  return net + tax;
}

// EUR型の eur を渡してもエラーにならない
// 公称型では USD と EUR は別物とされるので、エラーになるはず。
gross(eur, usd);
```

https://www.typescriptlang.org/ja/play?#code/C4TwDgpgBAqgygESgXigOwK4FsBGEBOA3AFCiRQCiMASiutnkccQMYD2aAzsFBpwCYAuWIjoBGAAwl2XHhAz5hVWqkklWHblADm+Np050AFGgjBh8BABoowAIYAPC4gCUzpMgB8UAN7EoUPhmCmjoZlAA1LaOJAC+zAD0CZQ0gNHqgHYMUPL4UIBJDICEdoDqDIBmDIBBDIAVDICXDIA-DIDWDIBWDICRDPWAIgzESVCANoqAD56pgOYMgPYMIkiAFgwptAOApEqAlk4jgKoMgDEMgNEM6X2AgAxVdfVLA4BaDIBADMS6+pxG2TZ8-C4kQA


上記をこのように解決したりする。この方法を Branded type と呼んだりする。
``` typescript
type USD = {
  _type: "USD";
  value: number;
}

type EUR = {
  _type: "EUR";
  value: number;
}

const usd: USD = { value: 10 } as USD
const eur: EUR = { value: 10 } as EUR

const gross = (net: USD, tax: USD): USD => {
  return { value: net.value + tax.value } as USD;
}

gross(usd, usd); // ok
gross(eur, usd); // Error: Property '_usdBrand' is missing in type 'EUR'.
```

https://www.typescriptlang.org/ja/play?#code/C4TwDgpgBAqgygESgXigbwFBSgfVJALigCJ4FiBuLKANwEMAbAVwiIDsmBbAIwgCcqAXwwZ80AKIwASinTU84ViUlTK1esyUce-ISIDGAezYBnYFCYmAJkTKy0tRiyIBGAAxRBUOidiIMRqbmEEx8RCr2jpquHl4+UCoiAGZMbPrAAJbGUADmfIYmJgAUbBDAtogANFDAdAAeFQgAlI1y2HxloWzoUc5QpcAAdBosUADUNfXDTtBxvmR6GHkFxZZW1WtNFFAA9DtQhgDWS-mFRSF8G9Zbu-vifPlhUAAK+ZB8oFAA5DhrAEJ8OhsKxfKAZXyccEmDJsHJg7pib4qL6DIA

cf.
- [構造的部分型 \(structural subtyping\) \| TypeScript入門『サバイバルTypeScript』](https://typescriptbook.jp/reference/values-types-variables/structural-subtyping)
- [Branded Typesを導入してみる / TypeScript一人カレンダー](https://zenn.dev/okunokentaro/articles/01gmpkp9gzfyr1za5wvrxt0vy6)

# Appendix
## type vs interface
あくまでも個人的な意見ではあるが、、
- 基本的にアプリケーション開発では interface は使わずに、 type を使うことを推奨する。
- ライブラリ開発のような使う側で拡張したい(Declaration merging したい)時は interface を使う。
  - 逆に言うと、interface はライブラリ開発くらいでしか使わないほうが良い
- interface を使う理由は拡張性で、使いたくない理由も拡張性という感じ

``` typescript
interface Person {
  name: string
}

interface Person {
  email: string
}

// Person を Declaration merging して name と email が存在するようにする。
// これを行うと、 いつの間にか Person が意図してない interface になりえる。
// 外部ライブラリで提供されている型を名前を変えないまま拡張したい時などに便利な機能だが、アプリケーション開発ではほぼ使わない。逆にデメリットのほうがでかい。
const john: Person = {
  name: "john",
  email: "hoge@example.com"
}
```

cf.
- [interfaceを使う理由は拡張性で、使いたくない理由も拡張性](https://zenn.dev/luvmini511/articles/6c6f69481c2d17)
- [TypeScript で type と interface どっち使うのか問題](https://zenn.dev/seya/articles/aa94166c977280#comment-9ec4de4f5c65a9)

## default export ではなく、 named export を使おう
### default export ver
``` typescript
// src/main.ts
import convertToISO8601 from './modules/converter'

async function run(startAt: Date) {
  console.log(
    convertToISO8601(startAt)
  )
}

run(new Date())
```

``` typescript
// src/modules/converter.ts
export default function (date: Date) {
  return date.toISOString()
}
```

- import 側で勝手な命名ができてしまうことで、 main.ts 以外の場所で別の名前で import されている可能性があり、検索性が悪く保守しにくい。

### named import ver
``` typescript
// src/main.ts
import { convertToISO8601 } from './modules/converter'

async function run(startAt: Date) {
  console.log(
    convertToISO8601(startAt)
  )
}

run(new Date())
```

``` typescript
// src/modules/converter.ts
export function convertToISO8601(date: Date) {
  return date.toISOString()
}
```

このようにすることで、 import する場合は `convertToISO8601` という名前を確実に使うことになるので、検索性が高く保守もしやすい。




cf.
- [なぜ default export を使うべきではないのか？](https://engineering.linecorp.com/ja/blog/you-dont-need-default-export/)

## class vs function
react の登場によりフロントエンドではクラスよりも関数で書くことが推奨されてきた。
関数は基本的には状態を持てないが、 hooks というしくみで関数でも状態をうまく扱う方法が発明されたことで、複雑なクラスを使うよりも関数を使うことが推奨され始めている。
状態コンテナがほしいのなら、 継承のような割れ窓になるものは廃した Go や Rust でいうところの struct でいいのではというのが最近のトレンドである。
Go や Rust ではそもそも class が存在しない。struct では状態コンテナとしての機能はあるが、いわゆる継承という機能はない。基本的に埋め込み(合成や移譲と呼んだりもする)を行い、 状態コンテナを拡張する。
JavaScript の class は継承があり、割れ窓になるので、使い所をしっかり見極めることが重要である。

継承では「親クラス」を指定してその機能を利用・拡張するのに対して、 埋め込み(合成、移譲)は構造体のフィールドとして別の構造体を保持して利用する。

関数型プログラミングだとドメインモデル貧血症(= ロジックとデータの分離)になりやすいのでは？という疑問がある。たしかに、 class だとメンバー(データ)とメソッド(ロジック) を一つの class に押し込めることでドメインモデルが実現しやすい。しかし、 関数型プログラミングにおいても、 class を使わずとも type(データ)と関数(ロジック)をモジュールの中に押し込めてしまえばいいのである。

<details>
<summary>閑話休題: DDD はオブジェクト指向を前提とした記事が多いが、いわゆる関数型プログラミングでもできるの？</summary>

[Domain Modeling Made Functional: Tackle Software Complexity with Domain\-Driven Design and F\# by Scott Wlaschin](https://pragprog.com/titles/swdddf/domain-modeling-made-functional/) を読もう。

</details>

cf.
- [現代のオブジェクト指向の class の割れ窓化と宣言的プログラミング](https://zenn.dev/mizchi/articles/oop-think-modern)


# 参考
- https://mixi-developers.mixi.co.jp/21-technical-training-a0bcdbf9bca0#ab3d
- [JavaScript 開発者ロードマップ: JavaScript を学ぶための段階的なガイド](https://roadmap.sh/javascript)
- [TypeScript Roadmap: Learn to become a TypeScript developer](https://roadmap.sh/typescript)
- [JavaScript イベントループの仕組みをGIFアニメで分かりやすく解説 \| コリス](https://coliss.com/articles/build-websites/operation/javascript/javascript-visualized-event-loop.html)
- [JavaScriptがブラウザでどのように動くのか \| メルカリエンジニアリング](https://engineering.mercari.com/blog/entry/20220128-3a0922eaa4/)
- [イベントループの概要と注意点｜イベントループとプロミスチェーンで学ぶJavaScriptの非同期処理](https://zenn.dev/estra/books/js-async-promise-chain-event-loop/viewer/2-epasync-event-loop)
- [Node\.jsでのイベントループの仕組みとタイマーについて \- hiroppy's site](https://hiroppy.me/blog/nodejs-event-loop/)
- [jsが非同期処理をシングルスレッドで実現する仕組み〜Web API、イベントループ、MicrotaskとしてのPromise〜](https://zenn.dev/canalun/articles/js_async_and_company)
- [描いて理解するイベントループ \- Qiita](https://qiita.com/kosuke-sugimori/items/a985864fc767d8bdfc4a)
- [それぞれのイベントループ｜イベントループとプロミスチェーンで学ぶJavaScriptの非同期処理](https://zenn.dev/estra/books/js-async-promise-chain-event-loop/viewer/c-epasync-what-event-loop)
- [それぞれのイベントループ｜イベントループとプロミスチェーンで学ぶJavaScriptの非同期処理](https://zenn.dev/estra/books/js-async-promise-chain-event-loop/viewer/c-epasync-what-event-loop#%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88%E3%83%AB%E3%83%BC%E3%83%97%E3%81%AE%E5%85%B1%E9%80%9A%E6%80%A7%E8%B3%AA)
- [JavaScriptがブラウザでどのように動くのか \| メルカリエンジニアリング](https://engineering.mercari.com/blog/entry/20220128-3a0922eaa4/)
