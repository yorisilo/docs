# cookie について
## cookie の基本仕様
- ブラウザに一度保存すれば、次から勝手に cookie を送る
- Origin に関係なくどこにでも送る (CORS を気にしないで送れる)
- 長さの制限しか無い(任意のシリアライズされた値を入れることができる)
cf.
- [HTTP Cookie の使用 \- HTTP \| MDN](https://developer.mozilla.org/ja/docs/Web/HTTP/Cookies)

<details>
<summary>Origin とは</summary>

ウェブコンテンツにアクセスするために使われる、プロトコル ex. http + ドメイン ex. localhost + ポート番号 8080 の3つを組み合わせたもの ex. http://localhost:8080 をオリジンと言う
cf. https://developer.mozilla.org/ja/docs/Glossary/Origin

</details>

ただし、最近はなんでもかんでも cookie を送りまくるのはセキュリティ的に問題だということで、 cookie のデフォルトの仕様も制限されるようになってきた。

### 具体例
HTTP の Set-Cookie レスポンスヘッダーは、サーバーがユーザーエージェントへ Cookie を送信するために使用する
``` http
Set-Cookie: <cookie-name>=<cookie-value>
```

例: サーバーのクライアントへのレスポンス

``` http
HTTP/2.0 200 OK
Content-Type: text/html
Set-Cookie: yummy_cookie=choco
Set-Cookie: tasty_cookie=strawberry

[ページの内容]
```

サーバーから Set-Cookie が返ってきたら、 クライアント(ブラウザ)は、 Cookie ヘッダーを使用してサーバーへ送信する

``` http
GET /sample_page.html HTTP/2.0
Host: www.example.org
Cookie: yummy_cookie=choco; tasty_cookie=strawberry
```

### 制限
> SameSite=Lax は SameSite が指定されなかった場合の新しい既定値です。 以前は、 Cookie は既定ですべてのリクエストに送信されていました。

1st party cookie

3rd party cookie

# cookie を触ってみよう


# 参考
- [HTTP Cookie の使用 \- HTTP \| MDN](https://developer.mozilla.org/ja/docs/Web/HTTP/Cookies)
- [Cookieの情報を【取得/保存/削除】する \- Qiita](https://qiita.com/mocha_xx/items/e0897e9f251da042af59)
- [常時SSLでもCookieの改ざんはできるワケ \- YouTube](https://www.youtube.com/watch?v=GP1eEit1quY)
- [基礎知識　Cookieの仕組み](https://www.soumu.go.jp/main_sosiki/joho_tsusin/security_previous/kiso/k01_cookie.htm)
- [牧歌的 Cookie の終焉 \| blog\.jxck\.io](https://blog.jxck.io/entries/2020-02-25/end-of-idyllic-cookie.html)
- [1st party Cookieと3rd party Cookieの違いとは？Cookieの規制とその影響も踏まえてご紹介！ \- Webマーケティングの次の一手を明らかに｜BE PLANNING](https://www.sowelleber.jp/beplanning/content/1st-party-cookie%E3%81%A83rd-party-cookie%E3%81%AE%E9%81%95%E3%81%84%E3%81%A8%E3%81%AF%EF%BC%9Fcookie%E3%81%AE%E8%A6%8F%E5%88%B6%E3%81%A8%E3%81%9D%E3%81%AE%E5%BD%B1%E9%9F%BF%E3%82%82%E8%B8%8F%E3%81%BE/)
- [なぜCookie同意取得が注目されるのか？同意取得の現状と注意ポイントを解説 \| Priv Lab](https://privtech.co.jp/blog/law/cookie_attention_reason.html)
- [Cookieの仕組みと役割とは？Cookie\(クッキー\)を適切に管理し、プライバシーを確保しよう \| OCN](https://service.ocn.ne.jp/ocn-security/case/column/20200116.html)
- [デフォルトでCookieをオリジンに紐づける、ChromeのOrigin\-Bound Cookies \- ASnoKaze blog](https://asnokaze.hatenablog.com/entry/2022/06/26/030130)
