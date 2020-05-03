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
