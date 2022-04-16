#!/usr/bin/env bash
# 此脚本用于自动备份 BitWarden 的文件

# crontab -e
# 0 0 15 * * /path/bitwarden_auto_bak.sh $1

set -e

FILE_NAME=bitwarden_bak_$(date +"%Y-%m-%d").tar.gz

file_path=${1}
cd "${file_path}/data/"
tar czf "${FILE_NAME}" ./*
mv "${FILE_NAME}" "${file_path}/backup/"
