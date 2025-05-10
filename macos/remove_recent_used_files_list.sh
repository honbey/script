#!/usr/bin/env bash
#

# Firstly, you need open terminal in the directory of recent files.

xattr -c ./*

for file in $(/usr/bin/env ls )
do
  if [[ -f "${file}" ]]; then
    cp -a "${file}" "${file}_" \
    && rm -f "${file}" \
    && mv "${file}_" "${file}"
  fi
done