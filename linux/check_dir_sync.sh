#!/usr/bin/env bash
#

a_dir=${1}
b_dir=${2}

ignore_suffix=".png"

find "${a_dir}" -type f | xargs md5sum > md5_a.txt
find "${b_dir}" -type f | xargs md5sum > md5_b.txt
# ssh $b_ip "find $dir -type f | xargs md5sum > /tmp/md5_b.txt"
# scp $b_ip:/tmp/md5_b.txt .

for f in $(awk '{print $2}' md5_a.txt)
do
  ff=${f#*/}
  if grep -q "${ff}" md5_b.txt
  then
    md5_a=$(grep -w "${ff}" md5_a.txt | awk '{print $1}')
    md5_b=$(grep -w "${ff}" md5_b.txt | awk '{print $1}')

    if [[ "${md5_a}" != "${md5_b}" ]]
    then
      echo "${f} changed."
    fi  
  else
    if [[ "${ff: -4}" != "${ignore_suffix}" ]]
    then
      echo "${f} deleted."
    fi  
  fi  
done