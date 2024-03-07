#!/usr/bin/env bash

# Show proxies
curl 127.0.0.1:1081/proxies | jq .

# Change proxy
curl -XPUT -d '{"name":""}' '127.0.0.1:1081/proxies/NAME'
