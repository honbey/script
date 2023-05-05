#!/usr/bin/env bash

rm -rf /tmp/tmp.*-fava.pid

nohup /opt/data/pyvenv/ledger/bin/fava /opt/data/server/ledger/main.bean > /dev/null 2>&1
&

TMPDIR="$(mktemp)"
echo $! > "${TMPDIR}-fava.pid"
rm -rf ${TMPDIR}
