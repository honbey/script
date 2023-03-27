#!/usr/bin/env bash

traceroute -n "$1" \
  cut -c 5-100 \
  awk '{printf "%2s %8s %2s %8s %2s %8s %2s  %-20s\n",FNR,$2,$3,$4,$5,$6,$7,$1}' 
