#!/usr/bin/env bash

set -e

content=""

files=$(ls "$1")
cd "$1"
c_path=$(pwd)

for f in ${files}; do
  eval $(echo "i=($(stat -t ${f} | awk '{print $1" "$2" "$13}'))")
  tmp="{\"type\":\"file\",\"filename\":\"${i[0]}\",\"updateTime\":\"${i[2]}\",\"size\":\"${i[1]}\",\"remark\":\"via CDN\"},"
  content="${content}${tmp}"
  echo "[${content:0:-1}]" > "${c_path}/../$1.json"
done
