2020-05-19 10:36:28

# 各種 editor で快適に js を扱うために
最近の js(ts) は、 html(正確にはjsx) やら、css やら graphql やら入ってて、
同じ言語の中に複数の言語が入っていて補完が効かなかったりしてつらいですよね。
それをある程度快適にします。

- jsx(tsx)
- styled-components
- graphql

を Typescript Language Server から良い感じに補完させます。

これらを導入すると良い感じで vscode で保管されるようになります。シンタックスハイライトについてはエディタのエクステンションでどうにかできるかも
- https://github.com/Microsoft/typescript-styled-plugin
- https://github.com/Quramy/ts-graphql-plugin

emacs の人は ts で使用する language-server を vscode の lauguage server に変えたら良い感じに動きます。

``` emacs-lisp
(setq lsp-clients-typescript-log-verbosity "debug"
      lsp-clients-typescript-plugins
        (vector
          (list :name "@vsintellicode/typescript-intellicode-plugin"
                :location "<home>/.vscode/extensions/visualstudioexptteam.vscodeintellicode-x.x.x/")))
```

cf.
- [Using Plugins In Typescript Language Server · emacs-lsp/lsp-mode Wiki](https://github.com/emacs-lsp/lsp-mode/wiki/Using-Plugins-In-Typescript-Language-Server)

## vscode の terminal で SIGINT を送る

keybind.json
``` json
{
  "key": "ctrl+c ctrl+c",
  "command": "workbench.action.terminal.sendSequence",
  "args": {
    "text": "\u0003" //
  },
  "when": "terminalFocus"
},
```

cf.
- [Integrated Terminal in Visual Studio Code](https://code.visualstudio.com/docs/editor/integrated-terminal#_send-text-from-a-keybinding)
- [visual studio code - Create a new keybinding that will send a Ctrl-C to VSCode terminal - Stack Overflow](https://stackoverflow.com/questions/52723989/create-a-new-keybinding-that-will-send-a-ctrl-c-to-vscode-terminal)
- [これは備忘録 ASCII文字コード](http://yasu0120.blog130.fc2.com/blog-entry-10.html)

## vscode の colorize を使って typescript でカラーコードにその色を出力させる
colorize.languages に typescriptreact を記入すればおｋ

setting.json
``` json
"colorize.languages": ["typescript", "typescriptreact", "javascript", "css", "scss"],
```

cf.
- [Not working in JS (astroturf) · Issue #233 · KamiKillertO/vscode-colorize](https://github.com/KamiKillertO/vscode-colorize/issues/233)
