2020-05-07 00:52:10

# コンピュータの構成と設計
- [マイクロプロセッサおよび演習](https://brain.cc.kogakuin.ac.jp/~kanamaru/lecture/MP/final/)

# メモリについて
- テキスト領域: プログラム(機械語)が置かれる。これを一行ずつ読んで実行していく
- 静的領域: global 変数などが置かれる場所
- ヒープ領域: new したり、動的にメモリを確保(malloc) したときに確保される場所
- スタック領域: ローカル変数などが置かれる場所

- [メモリの 4 領域](https://brain.cc.kogakuin.ac.jp/~kanamaru/lecture/MP/final/part06/node8.html)

# FizzBuzz をアセンブリで書く
- [#1: FizzBuzzをアセンブリ言語で書きたい！ - YouTube](https://www.youtube.com/watch?v=HFzk0fKDm_w)

## 使用コマンド
objdump: 逆アセンブル(実行ファイルからアセンブリを出す)するときに使う
gcc: c コンパイラ
ld: linker
man: セクションに応じたマニュアル出すやつ
mv: inode は同じままで名前を変更する

cf.
- [gccのアセンブル出力を解析する時は-gオプションが便利](http://nanoappli.com/blog/archives/3899)

### 閑話休題: man ページについて
セクション番号

| セクション番号 | 内容                                                             |
|:---------------|:-----------------------------------------------------------------|
| 1              | だれもが実行できるユーザーコマンド                               |
| 2              | システムコール（カーネルが提供する関数）                         |
| 3              | サブルーチン（ライブラリ関数）                                   |
| 4              | デバイス（/devディレクトリのスペシャルファイル）                 |
| 5              | ファイルフォーマットの説明（例：/etc/passwdなど）                |
| 6              | ゲーム                                                           |
| 7              | そのほか（例：マクロパッケージや取り決め的な文書など）           |
| 8              | システム管理者だけが実行できるシステム管理用のツール             |
| 9              | Linux独自のカーネルルーチン用ドキュメンテーション                |
| n              | 新しいドキュメンテーション（将来的には、適した場所に移動される） |
| o              | 古いドキュメンテーション（猶予期間として保存されている）         |
| l              | 独自のシステムについてのローカルなドキュメンテーション           |

``` shell
man chmod # man 1 chmod と同義
man 2 chmod
```

コマンドがどのセクションに属するかを調べるには、whatis or apropos コマンドを使用する。

``` shell
whatis chmod
apropos chmod
```

`whatis`コマンド
- 単語単位の完全一致検索
- 説明部分は検索対象外

`apropos`コマンド
- 部分一致検索
- 説明部分も検索対象

[manページの「関連事項」にあるsyslogd(8)などの数字は何？](https://www.atmarkit.co.jp/flinux/rensai/linuxtips/073mannum.html)

## まずは何もしないプログラムを書く
- レジスタに値を入れる
- syscall でそのレジスタを呼ぶ

exit syscall って何番？

- 検索する or c で何もしないプログラムを書いて、そのアセンブリを見る

### 何もしないプログラムを書いて、そのアセンブリを見る

``` shell
$ man 3 exit
```

test.c
``` c
#include <stdlib.h>

main() {
  exit(0);
}
```

``` shell
gcc -S test.c
cat test.s
```
