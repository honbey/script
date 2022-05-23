#!/usr/bin/env bash
# Update github hosts automatically. It should be executed by root user.

# 0 0 * * * /usr/bin/env bash /path/to/update_hosts.sh > /dev/null 2>&1

trap 'rm -rf "${tmp_dir}"' EXIT

tmp_dir=$(mktemp -d)

if [[ -d "${tmp_dir}" ]]; then
    curl -sfL https://gitlab.com/ineo6/hosts/-/raw/master/hosts -o "${tmp_dir}/hosts"
    echo -e "\n" >> "${tmp_dir}/hosts"

    sed -i "/# GITHUB BEGIN/,/# GITHUB END/!b;//!d;/# GITHUB BEGIN/r ${tmp_dir}/hosts" /etc/hosts
else
    echo "Making temporary directory fail!"
fi

