2021-06-04 10:46:02

開発環境晒し: 便利コマンドと設定の紹介

# gh コマンドを便利に使う
## gh コマンドとは
github 社が提供している公式の CLI ツール
コマンドライン上から、 github 上で行うもろもろの操作を行うことができる
(issue/pr を作ったり、見たりできる)

cf. https://github.com/cli/cli

# 準備

``` shell
$ brew install gh
$ brew install fzf
$ gh auth login
```

# issue を作成する

``` shell
gh issue create
```

# issue を便利に開く

カレントディレクトリのリポジトリの issue 一覧を開く
``` shell
gh issue list --limit 100 | fzf --reverse --cycle --ansi --multi --height ${FZF_TMUX_HEIGHT:-40%} --preview 'gh issue view {+1}' | awk '{print $1}' | xargs gh issue view --web
```

カレントディレクトリのリポジトリの issue 一覧(close したものも含め)を開く
``` shell
gh issue list --state all --limit 100 | fzf --reverse --cycle --ansi --multi --height ${FZF_TMUX_HEIGHT:-40%} --preview 'gh issue view {+1}' | awk '{print $1}' | xargs gh issue view --web
```

# PR を作成する

``` shell
gh pr create
```

# PR を便利に開く

カレントディレクトリのリポジトリの今いるブランチの PR を web ブラウザで開く(PRを作っていれば)
``` shell
gh pr view --web
```

カレントディレクトリのリポジトリの PR 一覧をプレビューしつつ web ブラウザで開く
``` shell
gh pr list --limit 100 | fzf --reverse --cycle --ansi --multi --height ${FZF_TMUX_HEIGHT:-40%} --preview "gh pr diff --color=always {+1}" | awk '{print $1}' | xargs gh pr view --web
```

# git log を便利にする

git log と 対応する diff を CLI 上から良い感じに見る
``` shell
git log --color=always --oneline --decorate --graph --date=format:'%H:%M:%S' --format=format:'%C(bold blue)%h%C(reset) %C(bold cyan)%ad%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset) %C(blue)%an %C(bold white)%s%C(reset)' --abbrev-commit "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --multi --height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
```

# 番外編

# git の root を一発で飛ぶ

リポジトリ内ののどこにいても root ディレクトリへ飛ぶ
``` shell
cd `git rev-parse --show-toplevel`
```

# git のサブコマンドの作り方
git は PATH の通ってる箇所に `git-hoge` というスクリプトを置いておくと、 `git hoge` のようにサブコマンドを定義できる機能がある。
