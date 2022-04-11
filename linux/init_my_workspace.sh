#!/usr/bin/env bash
# Script for initializing my workspace

set -e

CUR_PATH=$(pwd)

# PRI_GIT_URL=""

GITEE_URL="gitee.com"
GITHUB_URL="github.com"

if [[ ! -d "${CUR_PATH}/workspace" ]]; then
  mkdir ${CUR_PATH}/workspace
else
  rm -rf ${CUR_PATH}/workspace/*
fi

cd ${CUR_PATH}/workspace
# git clone git@${PRI_GIT_URL}:honbey/honbey.git

# Track all branches
function track_all_branches {
  git branch -r | \
  grep -v '\->' | \
  while read remote; do \
    git branch --track "${remote#origin/}" "${remote}"; \
  done
  git fetch --all
  git pull --all
}

repos=(
  "config" "script" "big-integer" "mzt" "dnspod-ddns" "certbot-auth-dnspod"
)

for repo in ${repos[*]}; do
  git clone git@${GITEE_URL}:honbey/${repo}.git
  cd ${CUR_PATH}/workspace/${repo} || exit
  git remote set-url --add origin git@${GITHUB_URL}:honbey/${repo}.git
  cd ${CUR_PATH}/workspace || exit
done

repos_dirs=("python" "web")

python_repos=(
  "m-image"
)

web_repos=(
  "kit-22"
)

for repos_dir in ${repos_dirs[*]}; do
  # mkdir ${CUR_PATH}/workspace/${repos_dir}
  repos=$(eval echo '$'{${repos_dir}_repos[*]})
  for repo in ${repos}; do
    # cd ${CUR_PATH}/workspace/${repos_dir}
    git clone git@${GITEE_URL}:honbey/${repo}.git
    # cd ${CUR_PATH}/workspace/${repos_dir}/${repo}
    cd ${CUR_PATH}/workspace/${repo} || exit
    git remote set-url --add origin git@${GITHUB_URL}:honbey/${repo}.git
    cd ${CUR_PATH}/workspace || exit
  done
done

# My private repository
pri_repos=("h-learning")
for repo in "${pri_repos[@]}"; do
  git clone git@${GITEE_URL}:honbey/${repo}.git
  cd ${CUR_PATH}/workspace/${repo} || exit
  track_all_branches
  git remote set-url --add origin git@${GITHUB_URL}:honbey/${repo}.git
  cd ${CUR_PATH}/workspace || exit
done

echo 'Done.'
