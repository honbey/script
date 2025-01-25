#!/usr/bin/env bash

DST_PORT="8989"
DST_ADDR="192.168.1.1"

SRC_PORT="22"
SRC_ADDR="10.0.0.1"

nohup socat TCP4-LISTEN:${DST_PORT},bind=${DST_ADDR},reuseaddr,fork TCP4:${SRC_ADDR}:$SRC_PORT >/dev/null 2>&1 &
