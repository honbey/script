#!/usr/bin/env bash
# 此脚本用于更改 git 仓库中的历史提交邮箱和用户名

git filter-branch --env-filter '
OLD_EMAIL="honbey@honbey.com"
CORRECT_NAME="honbey"
CORRECT_EMAIL="honbey@qq.com"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
  export GIT_COMMITTER_NAME="$CORRECT_NAME"
  export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
  export GIT_AUTHOR_NAME="$CORRECT_NAME"
  export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags

