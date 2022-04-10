#!/usr/bin/env bash
# 这个脚本用于更改当前目录的下的非正常权限文件
# 为正常权限（文件：644，目录：755）
if [[ ! -d "$1" ]]; then
  echo "The directory not exist!"
  exit 1
fi

find "$1" \
  \( \
    -type f \
    -not -perm 644 \
    -exec chmod 644 '{}' + \
  \) \
  -or \
  \( \
    -type d \
    -not -perm 755 \
    -exec chmod 755 '{}' + \
  \)

# 更改释伴行
# Mac
#sed -i '' 's/#!\/bin\/bash/#!\/usr\/bin\/env\ bash/' *.sh
# Linux
#sed -i 's/#!\/bin\/bash/#!\/usr\/bin\/env\ bash/' *.sh
