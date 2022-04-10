#!/usr/bin/env bash

to_be_updated_images=($(podman images | sed -n '2,$p' | awk '{print $1}'))

to_be_deleted_images=($(podman images | sed -n '2,$p' | awk '{print $3}'))

to_be_updated_containers=($(podman ps | sed -n '2,$p' | awk '{print $1}'))

for i in "${to_be_updated_containers[@]}"; do
  podman stop ${i}
  podman rm ${i}
done

for i in "${to_be_updated_images[@]}"; do
  podman pull ${i}
done

for i in "${to_be_deleted_images[@]}"; do
  podman rmi ${i}
done


# private command

podman run -d \
        --name bitwardenrs-server \
        --restart always \
        -e WEB_VAULT_ENABLED=true \
        -e DATABASE_URL=/data/bitwarden.db \
        -e LOG_FILE=/data/bitwarden.log \
        -e WEBSOCKET_ENABLED=true \
        -p 127.0.0.1:7000:80 \
        -p 127.0.0.1:7001:3012 \
        -v /root/bitwardenrs-server/data:/data \
        bitwardenrs/server:latest

podman run \
        --name ipsec-vpn-server \
        --restart=always \
        -v ikev2-vpn-data:/etc/ipsec.d \
        -p 500:500/udp \
        -p 4500:4500/udp \
        -d --privileged \
        hwdsl2/ipsec-vpn-server
