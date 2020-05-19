2020-05-05 05:14:13

gatsyby + netlify で ブログ CMS みたいなのは作れるのか？

- CMS なので、動的にブログを生成する必要がありそう

結論としては以下のように netlify CMS サービスを使えばできる。つまりブログ上で動的に生成するというよりも、 github push を自動的に行なってくれるサービスが別にある感じ。
まあ、gatsby はプリレンダリング(静的サイトジェネレーター)なのでそうですよね。
> CMSのページはhttps://*******.netlify.com/adminで、ページの更新やブログ記事の追加、画像の管理ができる。
> 更新後、「Publish」ボタンを押すと、更新した内容がgithubに自動的にプッシュされ、ビルドとデプロイが自動的に動く。
cf. [Netlify CMSのGatsbyJSテンプレートで個人ブロク作成(+TypeScript) - Qiita](https://qiita.com/otanu/items/f8840e66fb5e0993086d)

## プラグイン
cf.
- [GatsbyJSの基本 2 | hiko1129's note](https://note.hiko1129.com/1566475812885/)

GatsbyJS では GatsbyJS 固有のプラグインを入れて拡張していく

gatsby で styled-components(css in js) を使うには、

``` shell
$ yarn i --save gatsby-plugin-styled-components styled-components babel-plugin-styled-components
$ yarn i --save
```

gatsby-config.js
``` typescript
module.exports = {
  plugins: [`gatsby-plugin-styled-components`],
}
```

## データ
cf.
- [GatsbyJSの基本 2 | hiko1129's note](https://note.hiko1129.com/1566475812885)

> GatsbyJSにおけるデータとは、「Reactコンポーネントの外側にあるすべてのもの」です。具体的には、Markdown、CSV、データベース、API等のことを指します。
> GatsbyJSでデータを取得する場合は、基本的にGraphQLを使用します。

gatsby の graphQL で取得できるデータは

- gatsby-config.js に書いてある内容 <= デフォルト
- リポジトリのファイル <= プラグインが必要
- 外部のAPI <= プラグインが必要
- DB <= プラグインが必要
などなど

- Source Plugin: データソースを扱うためのプラグイン
- Transformer Plugin: データソースを変換するためのプラグイン

`gatsby-node.js` に自分でデータを追加する処理を書いても良いが、基本的なデータについてはプラグインが用意されてるので、  `gatsby-config.js` に用意されたプラグインを追加すればそのデータが使えるようになる。

cf.
- https://www.gatsbyjs.org/tutorial/part-four/

gatsby で graphQL を使ってデータを取得する方法

- pageQuery component
- StaticQuery component
- useStaticQuery hook
