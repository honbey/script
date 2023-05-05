#!/usr/bin/env bash

nohup /opt/data/pyvenv/ledger/bin/fava /opt/data/server/ledger/main.bean > /dev/null 2>&1
&

TMPDIR="$(mktemp)-fava.pid"
echo $! > "${TMPDIR}"
