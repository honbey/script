#!/usr/bin/env bash

TIME="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
CHERY_ACCESS_TOKEN="XXXXXX"

shopt -s expand_aliases

if [[ $1 != "force" ]]; then
  sleep "$(((RANDOM % 1200) + 300))s"
fi

curl --silent --compressed \
  -X OPTIONS "https://mobile-consumer-sapp.chery.cn/web/event/trigger?access_token=${CHERY_ACCESS_TOKEN}" \
  -H 'Accept: */*' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Access-Control-Request-Headers: authorization,content-type' \
  -H 'Access-Control-Request-Method: POST' \
  -H 'Accept-Language: zh-CN,zh;q=0.9,en-US;q=0.8,en;q=0.7' \
  -H 'Connection: keep-alive' \
  -H 'Origin: https://hybrid-sapp.chery.cn' \
  -H 'Referer: https://hybrid-sapp.chery.cn/' \  -H 'User-Agent: Mozilla/5.0 (Linux; Android 12; ZTE A2023P Build/SKQ1.220213.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Ch
rome/99.0.4844.88 Mobile Safari/537.36 android/1.0.0' \
  -H 'X-Requested-With: com.digitalmall.chery' \
  -H 'Sec-Fetch-Site: same-site' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Dest: empty'

res=$(curl --silent --compressed \
  -X POST "https://mobile-consumer-sapp.chery.cn/web/event/trigger?access_token=${CHERY_ACCESS_TOKEN}" \
  -H 'Accept: */*' \
  -H 'Accept-Language: zh-CN,zh' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H "Authorization: Bearer ${CHERY_ACCESS_TOKEN}" \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/json' \
  -H 'Origin: https://hybrid-sapp.chery.cn' \
  -H 'Referer: https://hybrid-sapp.chery.cn/' \
  -H 'User-Agent: Mozilla/5.0 (Linux; Android 12; ZTE A2023P Build/SKQ1.220213.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Ch
rome/99.0.4844.88 Mobile Safari/537.36 android/1.0.0' \
  -H 'X-Requested-With: com.digitalmall.chery' \
  -H 'Sec-Fetch-Site: same-site' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Dest: empty' \
  -d '{"eventCode":"SJ10002"}')

if [[ -f "/home/linuxbrew/.linuxbrew/bin/jq" ]]; then
  alias jq='/home/linuxbrew/.linuxbrew/bin/jq'
elif [[ -f "/opt/homebrew/bin/jq" ]]; then
  alias jq='/opt/homebew/bin/jq'
elif [[ -f "/usr/bin/jq" ]]; then
  alias jq='/usr/bin/jq'
else
  echo -e "${res}"
  exit 0
fi

echo -e "${res}" |
  jq "{time: \"${TIME}\", check_time: (now | todate), status: .status, message: .message}" --compact-output
exit 0
