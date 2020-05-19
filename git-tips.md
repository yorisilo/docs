2020-05-03 18:29:53

git-filter-branch は今は非推奨になってて、 使おうとすると git-filter-repo を使うように促される。

# 過去の username, mail を変更する

## git-filter-branch の場合
``` shell
$ git filter-branch -f --env-filter \
"GIT_AUTHOR_NAME='new'; \
GIT_AUTHOR_EMAIL='new@example.com'; \
GIT_COMMITTER_NAME='new'; \
GIT_COMMITTER_EMAIL='new@example.com';" \
HEAD
```
## git-filter-repo の場合

``` shell
$ brew install git-filter-repo
$ emacs .mailmap
新しい名前 <new@email.com> <old@email.com>
$ git filter-repo -f --mailmap .mailmap
```

# .gitignore の生成
- [.gitignore は、生成サービス gitignore.io を使って作ろう！ | Articles | Riotz.works](https://riotz.works/articles/lulzneko/2019/06/18/lets-create-gitignore-using-generation-service-gitignoreio/)

``` shell
# どんなものに対応しているか確認
curl https://www.gitignore.io/api/list
# node, nuxt の .gitignore を生成
curl https://www.gitignore.io/api/node,nuxt
```

# コンフリクト解消
cf.
- [Git rebaseでコンフリクト時のcheckoutオプションの--theirsと--ours - Qiita](https://qiita.com/shisho/items/c1075d394f1edf1a5928)
- [git の merge, rebase, revert で衝突した際の ours, theirs はどんな状態になるか - Qiita](https://qiita.com/nirasan/items/27cdd75e8117bf41d2be)


## 他のブランチを merge しようとしてコンフリクトした時
- ours: 現在のブランチの状態になる
- theirs: merge しようとしているブランチの状態になる
## 他のブランチを rebase しようとしてコンフリクトした時
- ours: rebase しようとしているブランチの状態になる
- theirs: 現在のブランチの状態になる

## 他のブランチの merge を revert しようとしてコンフリクトした時
- ours: merge 後に変更した状態になる
- theirs: merge 前の状態になる

### master への追いつきをする場合 rebase ver
git fetch origin master
git rebase origin/master
コンフリクト発生
コンフリクト修正
git add hoge or git restore --ours # origin/master のものを優先して取り込む
git rebase --continue

### master への追いつきをする場合 merge ver
git fetch origin master
git merge origin/master
コンフリクト発生
コンフリクト修正
git add hoge or git merge --theirs # origin/master のものを優先して取り込む
git merge --continue
