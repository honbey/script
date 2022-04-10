#!/usr/bin/env bash
# 每天自动备份 nginx 日志并压缩存储

# crontab -e
# 00 00 * * * /path/cut_nginx_logs.sh $1 $2 $3

set -e

log_path=${1}
access_log=${2}
error_log=${3}
date_str=$(date -d "yesterday" +%Y-%m-%d)
old_access_log=${log_path}/${date_str}-${access_log}
old_error_log=${log_path}/${date_str}-${error_log}

mv ${log_path}/${access_log} ${old_access_log}
mv ${log_path}/${error_log} ${old_error_log}

kill -USR1 $(cat ${log_path}/nginx.pid)

# not necessary
# sed -i 's/"[0-9]\+"/"0"/' /tmp/positions.yaml

if [[ ! -d "${log_path}/backups" ]]; then
  mkdir ${log_path}/backups
fi

gzip "${old_access_log}"
gzip "${old_error_log}"

mv "${old_access_log}.gz" ${log_path}/backups/
mv "${old_error_log}.gz" ${log_path}/backups/
