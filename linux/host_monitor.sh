#!/usr/bin/env bash
# Reference:
# https://www.fatalerrors.org/a/shell-script-case-collecting-system-cpu-memory-disk-and-network-information.html
# https://blog.csdn.net/bin_linux96/article/details/118531859
# https://www.jianshu.com/p/bc0eb83ef8d0


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
interval=5

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

init_cpu_usage=($(cpu_usage))
init_if1_flow=($(net_flow ${if1} 2 10))
init_if1_package=($(net_flow ${if1} 3 11))
init_if2_flow=($(net_flow ${if2} 2 10))
init_if2_package=($(net_flow ${if2} 3 11))
init_disk_in="$(disk_in)"
init_disk_out="$(disk_out)"
init_disk1_io=($(disk_io ${disk1}))
init_disk2_io=($(disk_io ${disk2}))

while true; do
  # date '+%H:%M:%S.%N'
  sleep ${interval}
  curr_cpu_usage=($(cpu_usage))
  curr_if1_flow=($(net_flow ${if1} 2 10))
  curr_if1_package=($(net_flow ${if1} 3 11))
  curr_if2_flow=($(net_flow ${if2} 2 10))
  curr_if2_package=($(net_flow ${if2} 3 11))
  curr_disk_in="$(disk_in)"
  curr_disk_out="$(disk_out)"
  curr_disk1_io=($(disk_io ${disk1}))
  curr_disk2_io=($(disk_io ${disk2}))

  curr_cpu_load=($(cpu_load))
  curr_app_mem="$(app_use_memory)"
  curr_mem="$(mem_usage Mem)"
  curr_swap="$(mem_usage Swap)"

  cpu_usage_per="$(awk '{print (($2 - $4) * 100) / ($1 - $3)}' <(echo "${curr_cpu_usage[@]} ${init_cpu_usage[@]}"))"

  # [0] down, [1] up
  if1_io_speed=($(awk '{print ($1 - $3) / '${ki}', ($2 - $4) / '${ki}'}' <(echo "${curr_if1_flow[@]} ${init_if1_flow[@]}")))
  if1_pkg_speed=($(awk '{print ($1 - $3) / '${interval}', ($2 - $4) / '${interval}'}' <(echo "${curr_if1_package[@]} ${init_if1_package[@]}")))
  if2_io_speed=($(awk '{print ($1 - $3) / '${ki}', ($2 - $4) / '${ki}'}' <(echo "${curr_if2_flow[@]} ${init_if2_flow[@]}")))
  if2_pkg_speed=($(awk '{print ($1 - $3) / '${interval}', ($2 - $4) / '${interval}'}' <(echo "${curr_if2_package[@]} ${init_if2_package[@]}")))

  disk_i_speed="$(awk '{printf "%.f", ($1 - $2) / '${interval}'}' <(echo "${curr_disk_in} ${init_disk_in}"))"
  disk_o_speed="$(awk '{printf "%.f", ($1 - $2) / '${interval}'}' <(echo "${curr_disk_out} ${init_disk_out}"))"

  # [0] read, [1] write
  disk1_speed=($(awk '{printf "%.f %.f", ($1 - $3) * 512 / '${ki}', ($2 - $4) * 512 / '${ki}'}' <(echo "${curr_disk1_io[@]} ${init_disk1_io[@]}")))
  disk2_speed=($(awk '{printf "%.f %.f", ($1 - $3) * 512 / '${ki}', ($2 - $4) * 512 / '${ki}'}' <(echo "${curr_disk2_io[@]} ${init_disk2_io[@]}")))

  s0="{\"timestamp\":\"$(date -u "+%Y-%m-%dT%H:%M:%S.%NZ")\",\"cpu_usage_per\":${cpu_usage_per}"
  s1=",\"cpu_load_1\":${curr_cpu_load[0]},\"cpu_load_5\":${curr_cpu_load[1]},\"cpu_load_15\":${curr_cpu_load[2]}"
  s2=",\"app_mem\":${curr_app_mem},\"used_mem\":${curr_mem},\"total_mem\":${total_mem}"
  s3=",\"used_swap\":${curr_swap},\"total_swap\":${total_swap}"
  s4=",\"network\":{\"if1_in\":${if1_io_speed[0]},\"if1_out\":${if1_io_speed[1]}"
  s5=",\"if1_pkg_in\":${if1_pkg_speed[0]},\"if1_pkg_out\":${if1_pkg_speed[1]}"
  s6=",\"if2_in\":${if2_io_speed[0]},\"if2_out\":${if2_io_speed[1]}"
  s7=",\"if2_pkg_in\":${if2_pkg_speed[0]},\"if2_pkg_out\":${if2_pkg_speed[1]}}"
  s8=",\"disk\":{\"disk_out\":${disk_i_speed},\"disk_in\":${disk_o_speed}"
  s9=",\"disk1_read\":${disk1_speed[0]},\"disk1_write\":${disk1_speed[1]}"
  s10=",\"disk2_read\":${disk2_speed[0]},\"disk2_write\":${disk2_speed[1]}}}"

  echo "${s0}${s1}${s2}${s3}${s4}${s5}${s6}${s7}${s8}${s9}${s10}"

  init_cpu_usage=(${curr_cpu_usage[@]})
  init_if1_flow=(${curr_if1_flow[@]})
  init_if1_package=(${curr_if1_package[@]})
  init_if2_flow=(${curr_if2_flow[@]})
  init_if2_package=(${curr_if2_package[@]})
  init_disk_in="${curr_disk_in}"
  init_disk_out="${curr_disk_out}"
  init_disk1_io=(${curr_disk1_io[@]})
  init_disk2_io=(${curr_disk2_io[@]})
done

