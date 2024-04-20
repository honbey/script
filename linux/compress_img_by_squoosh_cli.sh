#!/usr/bin/env bash

date

# Using linuxbrew
if [[ -d /home/linuxbrew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Reference: https://github.com/GoogleChromeLabs/squoosh/issues/1033#issuecomment-1736435804
export NODE_OPTIONS='--no-experimental-fetch'

# use `auto` will casu oom
/opt/data/pnpm/squoosh-cli --webp '{"quality":80,"baseline":false,"arithmetic":false,"progressive":true,"optimize_coding":true,"smoothing":0,"color_space":3,"quant_table":3,"trellis_multipass":false,"trellis_opt_zero":false,"trellis_opt_table":false,"trellis_loops":1,"auto_subsample":true,"chroma_subsample":2,"separate_chroma_quality":false,"chroma_quality":75}' \
  -d "${1}" "${2}"

if [[ $? == 0 ]]; then
  /usr/bin/env rm -rf "${2}"/*
else
  echo 'ececute failed, not remove origin image'
fi
