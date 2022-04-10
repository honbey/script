#!/usr/bin/env bash
# 

pip list --outdated | sed -n '3,$p' | awk '{print $1}' > upgrade.txt
cat < upgrade.txt | xargs pip install --upgrade
rm upgrade.txt