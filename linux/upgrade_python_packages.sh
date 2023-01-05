#!/usr/bin/env bash
# 

pip list --outdated | sed -n '3,$p' | awk '{print $1}' > upgrade.txt
cat < upgrade.txt | xargs pip install --upgrade-strategy only-if-needed
rm upgrade.txt
