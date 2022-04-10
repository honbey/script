#!/usr/bin/env bash
#

user_name=${1}
user_email=${2}

for git_repo in $(/usr/bin/env ls )
do
  cd "${git_repo}" || exit
  if [[ "$(git config user.name)" != "${user_name}" ]]; then
    git config user.name "${user_name}"
  elif [[ "$(git config user.email)" != "${user_email}" ]]; then
    git config user.email "${user_email}"
  fi
  cd ..
done