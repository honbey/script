#!/usr/bin/env bash

date

# use `auto` will casu oom
squoosh-cli --webp '{"quality":80,"baseline":false,"arithmetic":false,"progressive":true,"optimize_coding":true,"smoothing":0,"color_space":3,"quant_table":3,"trellis_multipass":false,"trellis_opt_zero":false,"trellis_opt_table":false,"trellis_loops":1,"auto_subsample":true,"chroma_subsample":2,"separate_chroma_quality":false,"chroma_quality":75}' \
  -d "${1}"     \
  "${2}"

/usr/bin/env rm -rf "${2}"/*
