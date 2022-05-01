#!/usr/bin/env bash

tmux has-session -t workspace

if [[ $? != 0 ]]; then
  tmux new-session -s workspace -n z0 -d

  tmux new-window -n blg -t workspace
  tmux new-window -n ws1 -t workspace
  tmux new-window -n ws2 -t workspace
  tmux new-window -n log -t workspace
  tmux new-window -n dls -t workspace
  tmux new-window -n tmp -t workspace

  tmux send-keys -t workspace:1 'cd /data/workspace/honbey-blog' C-m
  tmux send-keys -t workspace:2 'cd /data/workspace' C-m
  tmux send-keys -t workspace:3 'cd /data/workspace' C-m
  tmux send-keys -t workspace:4 'cd /data/logs' C-m
  tmux send-keys -t workspace:5 'cd /data/freewisdom.cn/dl' C-m
  
  if [[ "$1" == "r" ]]; then
    tmux send-keys -t workspace:6 'cp -r /data/freewisdom.cn/dl/web-vault /tmp' C-m
    tmux send-keys -t workspace:6 'cp -r /data/freewisdom.cn/dl/grafana-oss /tmp' C-m
    tmux send-keys -t workspace:6 'cd /data/logs/host && nohup bash /data/logs/host/host_monitor.sh > /dev/null 2>&1 &' C-m
    tmux send-keys -t workspace:6 'cd /data/server/anki/src && nohup /data/pyvenv/anki/bin/python -m ankisyncd > /dev/null 2>&1 &' C-m
    tmux send-keys -t workspace:6 'cd /data/server/vaultwarden' C-m
    tmux send-keys -t workspace:6 'nohup /data/pyvenv/podman/bin/podman-compose start > /dev/null 2>&1' C-m
    tmux send-keys -t workspace:6 'cd /data/server/glp' C-m
    tmux send-keys -t workspace:6 'nohup /data/pyvenv/podman/bin/podman-compose start > /dev/null 2>&1' C-m
    tmux send-keys -t workspace:6 'cd /data/server/mysql' C-m
    tmux send-keys -t workspace:6 'nohup /data/pyvenv/podman/bin/podman-compose start > /dev/null 2>&1' C-m
    tmux send-keys -t workspace:6 'cd /data/server/ghost' C-m
    tmux send-keys -t workspace:6 'nohup /data/pyvenv/podman/bin/podman-compose start > /dev/null 2>&1' C-m
    tmux send-keys -t workspace:6 '/usr/local/nginx-quic/sbin/nginx && cd' C-m
  fi

  tmux select-window -t workspace:1
fi

tmux attach -t workspace
