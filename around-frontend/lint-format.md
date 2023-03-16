# linter, formatter
- linter: eslint
- formatter: prettier

# 導入する package
- eslint
- eslint-config-prettier (eslint の prettier と競合するルールをオフにする)
- prettier

``` shell
# linter, formatter
npm install --save-dev @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint eslint-config-prettier prettier

# typescript
npm install --save-dev typescript typescript-language-server
```

# 参考
- [いつのまにかeslint\-plugin\-prettierが推奨されないものになってた \| K note\.dev](https://knote.dev/post/2020-08-29/duprecated-eslint-plugin-prettier/)
- [prettier,eslintを導入する際にハマったこと2021新年](https://zenn.dev/ryusou/articles/nodejs-prettier-eslint2021)
