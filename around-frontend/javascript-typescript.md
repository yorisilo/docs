# フロントエンド JavaScript/TypeScript

# JavaScript
ECMAScript によって、仕様規定された言語

ランタイムによって、言語の実装が異なる。
- ブラウザ
- Nodejs
- Deno など

シンタックスはほぼ同じなんだけど、実際にどう動くかはランタイム依存
基本的にそれぞれのランタイムはシングルスレッドで動くように実装されているので、並列処理はできないのだが、 worker と呼ばれるものに処理を委譲することで、並列処理を実現している。
最近は、ブラウザに web worker API と呼ばれるマルチスレッドで js の処理を行う仕組みが実装され始めているが、今回は触れない。
シングルスレッドなランタイムなのに、非同期処理が実現できるのはなぜか。

# 非同期処理とイベントループ
- [jsが非同期処理をシングルスレッドで実現する仕組み〜Web API、イベントループ、MicrotaskとしてのPromise〜](https://zenn.dev/canalun/articles/js_async_and_company)
- [描いて理解するイベントループ \- Qiita](https://qiita.com/kosuke-sugimori/items/a985864fc767d8bdfc4a)
- [それぞれのイベントループ｜イベントループとプロミスチェーンで学ぶJavaScriptの非同期処理](https://zenn.dev/estra/books/js-async-promise-chain-event-loop/viewer/c-epasync-what-event-loop)
- [それぞれのイベントループ｜イベントループとプロミスチェーンで学ぶJavaScriptの非同期処理](https://zenn.dev/estra/books/js-async-promise-chain-event-loop/viewer/c-epasync-what-event-loop#%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88%E3%83%AB%E3%83%BC%E3%83%97%E3%81%AE%E5%85%B1%E9%80%9A%E6%80%A7%E8%B3%AA)
- [JavaScriptがブラウザでどのように動くのか \| メルカリエンジニアリング](https://engineering.mercari.com/blog/entry/20220128-3a0922eaa4/)

JavaScript のランタイムは基本的にシングルスレッドで一度に実行できるタスクは1つだけであるが、JavaScript の各種ランタイム(ブラウザとか Node とか Deno とか)ではイベントループを実装しており、非同期で処理を行う仕組みが導入されている。
JavaScript はブラウザのメインスレッドで実行されるので、30秒かかるタスクを実行すると、その時間はブラウザが動かなくなる。
なので、イベントループの仕組みを使った非同期処理を頻繁に使用することになる。
よくある Ajax 関係の処理はほぼ100%が非同期である。

<details>
<summary>ランタイム</summary>

実行環境と呼ばれたりする
コードを解釈し処理を実行するためのもろもろ

</details>

JavaScriptにはイベント置き場というものがあり、
「Aが起きたら、この関数を実行する」というイベント登録しておき、
裏で高速に循環しているイベントループがイベントの発火条件を満たしたものから順番に実行するという流れになっている。

<details>
<summary>イベントループ</summary>

</details>


具体的には先方のサーバーにHTTPリクエストを発射するよう、「ブラウザが所持しているAPI(Web API と呼ばれる)にお願い」と同時にイベント置き場にコールバック関数を設置してすぐ逃げる仕組みになっている

# 非同期処理と同期処理の扱いの歴史
callback hell

promise then

async await

# イベントループ

# TypeScript
JavaScript と型システムを合体させたもの
TypeScript は JavaScript のスーパーセットなので、 JavaScript のコードは基本的にそのままで動きます。

## 型で遊ぼう
TypeScript の型はチューリング完全
型レベルで足し算とかできたりする。

# アンチパターン
## default export の問題点
- [なぜ default export を使うべきではないのか？](https://engineering.linecorp.com/ja/blog/you-dont-need-default-export/)

# CommonJS(require) と ES Modules(import)

# 参考
- https://mixi-developers.mixi.co.jp/21-technical-training-a0bcdbf9bca0#ab3d
- [JavaScript 開発者ロードマップ: JavaScript を学ぶための段階的なガイド](https://roadmap.sh/javascript)
- [TypeScript Roadmap: Learn to become a TypeScript developer](https://roadmap.sh/typescript)
- [JavaScript イベントループの仕組みをGIFアニメで分かりやすく解説 \| コリス](https://coliss.com/articles/build-websites/operation/javascript/javascript-visualized-event-loop.html)
- [JavaScriptがブラウザでどのように動くのか \| メルカリエンジニアリング](https://engineering.mercari.com/blog/entry/20220128-3a0922eaa4/)
- [イベントループの概要と注意点｜イベントループとプロミスチェーンで学ぶJavaScriptの非同期処理](https://zenn.dev/estra/books/js-async-promise-chain-event-loop/viewer/2-epasync-event-loop)
