#!/usr/bin/env bash

for i in $(ls); do
        if [[ ${i} =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}.* ]]; then
                rename=$(echo ${i} | sed -n 's/\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)-\(.*\).gz/\4-\1\2\3.gz/p')
                echo ${rename}
                mv ${i} ${rename}
        fi
done
