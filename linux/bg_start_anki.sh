#!/usr/bin/env bash

SYNC_USER1=${1}:${2}
SYNC_BASE=/opt/data/server/anki
SYNC_HOST=127.0.0.1
SYNC_PORT=1050

nohup /opt/data/pyvenv/anki/bin/python -m anki.syncserver > /opt/data/log/anki.log 2>&1 &

TMPDIR="$(mktemp)-anki.pid"
echo $! > "${TMPDIR}"
