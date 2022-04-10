#!/usr/bin/env bash
# Script for initializing my workspace

set -e

CUR_PATH=$(pwd)

# PRI_GIT_URL=""

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
  "honbey.github.io" "config-and-scripts" "big-integer"
)

for repo in ${repos[*]}; do
  git clone git@${GITHUB_URL}:honbey/${repo}.git
done

repos_dirs=("python")

python_repos=(
  "m-image"
)

#web_repos=(
#  "web"
#)

for repos_dir in ${repos_dirs[*]}; do
  # mkdir ${CUR_PATH}/workspace/${repos_dir}
  repos=$(eval echo '$'{${repos_dir}_repos[*]})
  for repo in ${repos}; do
    # cd ${CUR_PATH}/workspace/${repos_dir}
    git clone git@${GITHUB_URL}:honbey/${repo}.git
    # cd ${CUR_PATH}/workspace/${repos_dir}/${repo}
    # git remote set-url --add origin git@${GITHUB_URL}:honbey/${repo}.git
  done
done

# My private repository
pri_repos=("h-learning")
for repo in "${pri_repos[@]}"; do
  git clone git@${GITHUB_URL}:honbey/${repo}.git
  track_all_branches
done

echo 'Done.'
