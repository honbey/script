#!/usr/bin/env bash
# @version 1.1.0
# Reference:
# https://www.fatalerrors.org/a/shell-script-case-collecting-system-cpu-memory-disk-and-network-information.html
# https://blog.csdn.net/bin_linux96/article/details/118531859
# https://www.jianshu.com/p/bc0eb83ef8d0

echo "$$" > ./pid

function cpu_usage {
  local usage=($(awk -v total=0 '
    /cpu / {
      $1="";
      for (i=2;i<NF;i++) {
        total+=$i
      };
      used=$2+$3+$4+$7+$8
    } END {
      print total, used
    }' /proc/stat
  ))
  echo ${usage[@]}
}

function cpu_load {
  local load=($(awk '{print $1, $2, $3}' /proc/loadavg))
  echo ${load[@]}
}

function app_use_memory {
  echo "$(awk '
    /MemTotal/{total=$2}/MemFree/{free=$2}/Buffers/{buffers=2}/^Cached/{cached=$2}
    END {print (total - free - buffers - cached) / 1024}
  ' /proc/meminfo)"
}

function mem_usage {
  echo "$(awk '
    /'$1'Total/{total=$2}/'$1'Free/{free=$2}
    END {print (total - free) / 1024}
  ' /proc/meminfo)"
}

function disk_in {
  local pgin="$(awk '/pgpgin/{print $2}' /proc/vmstat)"
  echo "${pgin}"
}

function disk_out {
  local pgout="$(awk '/pgpgout/{print $2}' /proc/vmstat)"
  echo "${pgout}"
}

function disk_io {
  local io=($(awk '/'$1' /{print $6, $10}' /proc/diskstats))
  echo ${io[@]}
}

function net_flow {
  local bytes=($(awk -v eth=$1 '
    BEGIN {ORS=" "}
    /'$1':/{print $'$2', $'$3'}
  ' /proc/net/dev))
  echo ${bytes[@]}
}

# Host Monitor by infinite loop, you can also use crontab.
interval=10

# Interface configuration
if1="eno1"
if2="vboxnet0"

# Disk configuration
disk1="nvme0n1"
disk2="sda"

#
total_mem="$(awk '/MemTotal/{total=$2} END {print total / 1024}' /proc/meminfo)"
total_swap="$(awk '/SwapTotal/{total=$2} END {print total / 1024}' /proc/meminfo)"

if [[ ${total_swap} == 0 ]]; then
  total_swap=0.1
fi

ki=$(( interval * 1024 ))

init_array=(                            # capcity  index
  "$(date -u '+%Y-%m-%dT%H:%M:%S.%NZ')" # 1        0
  $(cpu_usage)                          # 2        1
  "0" "0" "0"                           # 2        3      avg load
  "0" "0" "0" "0" "0"                   # 5        6      memory and swap
  $(net_flow ${if1} 2 10)               # 2        11
  $(net_flow ${if1} 3 11)               # 2        13
  $(net_flow ${if2} 2 10)               # 2        15
  $(net_flow ${if2} 3 11)               # 2        17
  "$(disk_in)"                          # 1        19
  "$(disk_out)"                         # 1        20
  $(disk_io ${disk1})                   # 2        21
  $(disk_io ${disk2})                   # 2        23
)

while true; do
  #date '+%H:%M:%S.%N'
  # Asynchronous execute
  sleep ${interval} &
  pid=$!

  curr_array=(                            # capcity  index
    "$(date -u '+%Y-%m-%dT%H:%M:%S.%NZ')" # 1        0
    $(cpu_usage)                          # 2        1
    $(cpu_load)                           # 2        3      avg load
    "$(app_use_memory)" "$(mem_usage Mem)" "${total_mem}"
    "$(mem_usage Swap)" "${total_swap}"   # 2        9      swap
    $(net_flow ${if1} 2 10)               # 2        11
    $(net_flow ${if1} 3 11)               # 2        13
    $(net_flow ${if2} 2 10)               # 2        15
    $(net_flow ${if2} 3 11)               # 2        17
    "$(disk_in)"                          # 1        19
    "$(disk_out)"                         # 1        20
    $(disk_io ${disk1})                   # 2        21
    $(disk_io ${disk2})                   # 2        23
  ) # Total 25

  awk '{
    printf "{\
\"timestamp\":\"%s\", \"cpu_usage\":%.2f,\
\"cpu_load_1\":%.2f,\"cpu_load_5\":%.2f,\"cpu_load_15\":%.2f,\
\"app_mem\":%.2f,\"used_mem\":%.2f,\"total_mem\":%.2f,\
\"app_swap\":%.2f,\"total_swap\":%.2f,\
\"network\":{\
\"if1_in\":%.2f,\"if1_out\":%.2f,\
\"if1_pkg_in\":%.2f,\"if1_pkg_out\":%.2f,\
\"if2_in\":%.2f,\"if2_out\":%.2f,\
\"if2_pkg_in\":%.2f,\"if2_pkg_out\":%.2f\
},\
\"disk\":{\
\"disk_out\":%.2f,\"disk_in\":%.2f,\
\"disk1_read\":%.2f,\"disk1_write\":%.2f,\
\"disk2_read\":%.2f,\"disk2_write\":%.2f\
}}\n", $1,($3-$28)*100/($2-$27),$4,$5,$6,$7,$8,$9,$10,$11,
    ($12-$37)/'${ki}',($13-$38)/'${ki}',($14-$39)/'${interval}',($15-$40)/'${interval}',
    ($16-$41)/'${ki}',($17-$42)/'${ki}',($18-$43)/'${interval}',($19-$44)/'${interval}',
    ($20-$45)/'${interval}',($21-$46)/'${interval}',
    ($22-$47)*0.5/'${interval}',($23-$48)*0.5/'${interval}',
    ($24-$49)*0.5/'${interval}',($25-$50)*0.5/'${interval}'
  }' <(echo "${curr_array[@]}" "${init_array[@]}") >> ./json_host.log

  init_array=(${curr_array[@]})

  wait ${pid}
done
