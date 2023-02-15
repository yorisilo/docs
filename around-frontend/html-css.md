# HTML CSS

# HTML とは
HTML: Hypertext Markup Languge
- [HTML Standard](https://html.spec.whatwg.org/multipage/)

web page の記述言語

こういうやつ

``` html
<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Tutorial 1</title>
  </head>
  <body>
    <h1>Tutorial 1</h1>
    <p>devtool から console を開いてください。</p>
    <script src="a.js"></script>
    <script src="b.js"></script>
  </body>
</html>
```


HTML5 が廃止されて、2021年1月 HTML Living Standard を正式な HTML 仕様として W3C が発表した。

皆さんよく知ってると思うので具体的なタグや使い方は触れない。

js 等でよく話題に出てくるイベントループは実は、 js の言語仕様にはなく、 HTML の仕様である。
つまり、ブラウザや Node.js がこの HTML の仕様に合わせてランタイムを作っている。
https://html.spec.whatwg.org/multipage/webappapis.html#event-loops

# CSS とは
Cascading Style Sheets
- [CSS: カスケーディングスタイルシート \| MDN](https://developer.mozilla.org/ja/docs/Web/CSS)

web ページを装飾するための言語

こういうやつ

``` css
.button {
  font-size: 1.6rem;
  font-weight: 700;
  position: absolute;
}
```

## CSS 設計の変遷
CSS -> SASSとか -> BEMとか -> CSS Modules -> CSS in JS(Styled Components, emotion...)

## CSS
CSS には名前空間が存在しない(グローバルスコープ)なので、スタイルの影響範囲がわからない。
スタイルが効かないみたいなことが頻発する。

## かつての対応策
- SASS(SCSS)
- BEM

こんな感じで命名規則で名前空間を独自に作って対応したりしてた。
``` html
<div class="block">
  <div class="block__element"></div>
  <div class="block__element--modifier"></div>
</div>
<div class="block--modifier">
  <div class="block--modifier__element"></div>
</div>
```

## CSS Modules
webpack 等の css-loader の module mode を使うとローカルな CSS が実現できる。

- BEMのように人力で行っていたローカル化を、webpackが自動で行ってくれる。いわば、ローカルCSSのオートメーション化。
- クラス名の衝突を開発者が気にする必要がなくなった。


これが
``` css
// common.css
.button {
  ...
}
```

このように変換される
``` css
// application.css
.common-button-1DYla {
  ...
}
```

こんな感じで使う

``` jsx
import commonStyles from '../stylesheets/common.css'

<button className={commonStyles.button} />
```

## CSS in JS
今までは、 html, css, js とファイルを分けて構成していたが、コンポーネント単位で html, css, js をまとめて記述しようという機運が高まってきた。
CSS in JS では css の記述を js ファイルに記載して、 css のスコープをそのコンポーネントに閉じようというコンセプトでスタイリングを行う手法。

- styled-components
- emotion
など


``` vue
<script>
import styled from 'vue-styled-components';

const btnProps = { primary: Boolean };

const StyledButton = styled('button', btnProps)`
  font-size: 1em;
  margin: 1em;
  padding: 0.25em 1em;
  border: 2px solid palevioletred;
  border-radius: 3px;
  background: ${props => props.primary ? 'palevioletred' : 'white'};
  color: ${props => props.primary ? 'white' : 'palevioletred'};
`;

export default StyledButton;
</script>
```

使い方
``` vue
<styled-button>Normal</styled-button>
<styled-button primary>Primary</styled-button>
```

# 参考
- [https://www\.ietf\.org/rfc/rfc1866\.txt](https://www.ietf.org/rfc/rfc1866.txt)
- [HTML Living Standardとは？廃止されたHTML5との違いなど徹底解説！｜SEOラボ](https://seolaboratory.jp/49735/)
- [Sassなしで入れ子が可能に。CSSネストがブラウザにやってきた](https://zenn.dev/moneyforward/articles/css-nesting-without-sass)
- [コードの違いを比較！emotionとstyled\-componentsの両方を使ってみた \- Qiita](https://qiita.com/chika_hoge/items/4efcacb3aee34307076c)
- [Vue\.jsのscoped CSSは意外とバッティングする \- Qiita](https://qiita.com/wintyo/items/dfc232255ad45fdf376f)
- [Sass、別に言うほどいらない説 \| セカヤサブログ](https://itokoba.com/archives/2332)
- [CSS設計って将来消えますか？ \- Quora](https://jp.quora.com/CSS%E8%A8%AD%E8%A8%88%E3%81%A3%E3%81%A6%E5%B0%86%E6%9D%A5%E6%B6%88%E3%81%88%E3%81%BE%E3%81%99%E3%81%8B)
- [ShopifyテーマでSassが非推奨となります \- Shopify 日本](https://www.shopify.com/jp/blog/partner-theme-sass-depricated)
