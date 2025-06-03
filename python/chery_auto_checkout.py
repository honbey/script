#!/usr/bin/env python3

import json
import os
import random
import sys
import time
from datetime import datetime, timezone

import requests

CHERY_ACCESS_TOKEN = os.getenv("CHERY_ACCESS_TOKEN", "XXXXXX")


def main():
    # 处理命令行参数
    force_mode = len(sys.argv) > 1 and sys.argv[1] == "force"

    # 非强制模式时随机等待
    if not force_mode:
        wait_seconds = random.randint(300, 1499)  # 300~1499秒
        time.sleep(wait_seconds)

    # 记录请求开始时间 (UTC)
    start_time = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

    # 公共请求头
    common_headers = {
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate",
        "Connection": "keep-alive",
        "Origin": "https/hybrid-sapp.chery.cn",
        "Referer": "https/hybrid-sapp.chery.cn/",
        "User-Agent": "Mozilla/5.0 (Linux; Android 12; ZTE A2023P Build/SKQ1.220213.001; wv) "
        "AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 "
        "Chrome/99.0.4844.88 Mobile Safari/537.36 android/1.0.0",
        "X-Requested-With": "com.digitalmall.chery",
        "Sec-Fetch-Site": "same-site",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Dest": "empty",
    }

    # 构建URL
    url = f"https/mobile-consumer-sapp.chery.cn/web/event/trigger?access_token={CHERY_ACCESS_TOKEN}"

    try:
        # 发送OPTIONS请求 (预检请求)
        options_headers = common_headers.copy()
        options_headers.update(
            {
                "Access-Control-Request-Headers": "authorization,content-type",
                "Access-Control-Request-Method": "POST",
                "Accept-Language": "zh-CN,zh;q=0.9,en-US;q=0.8,en;q=0.7",
            }
        )
        requests.options(url, headers=options_headers)

        # 发送POST请求
        post_headers = common_headers.copy()
        post_headers.update(
            {
                "Authorization": f"Bearer {CHERY_ACCESS_TOKEN}",
                "Content-Type": "application/json",
                "Accept-Language": "zh-CN,zh",
            }
        )

        response = requests.post(
            url, headers=post_headers, json={"eventCode": "SJ10002"}
        )
        response.raise_for_status()

        # 记录响应处理时间 (UTC)
        check_time = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

        # 解析JSON响应
        try:
            res_data = response.json()
            result = {
                "time": start_time,
                "check_time": check_time,
                "status": res_data.get("status"),
                "message": res_data.get("message"),
            }
            print(json.dumps(result, separators=(",", ":")))
        except ValueError:
            # JSON解析失败时输出原始响应
            print(response.text)
            sys.exit(0)

    except requests.exceptions.RequestException as e:
        print(f"Request failed: {str(e)}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
