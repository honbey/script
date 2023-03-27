#!/usr/bin/env bash

files=(
    "/Library/Application Support/VMware/VMware Fusion"
    "/Library/Application Support/VMware/Usbarb.rules"
    "/Library/Application Support/VMware Fusion"
    "/Library/Preferences/VMware Fusion"
    "/private/etc/paths.d/com.vmware.fusion.public"
    "$HOME/Library/Application Support/VMware Fusion"
    "$HOME/Library/Caches/com.vmware.fusion"
    "$HOME/Library/Preferences/VMware Fusion"
    "$HOME/Library/Preferences/com.vmware.fusion.LSSharedFileList.plist"
    "$HOME/Library/Preferences/com.vmware.fusion.LSSharedFileList.plist.lockfile"
    "$HOME/Library/Preferences/com.vmware.fusion.plist"
    "$HOME/Library/Preferences/com.vmware.fusion.plist.lockfile"
    "$HOME/Library/Preferences/com.vmware.fusionDaemon.plist"
    "$HOME/Library/Preferences/com.vmware.fusionDaemon.plist.lockfile"
    "$HOME/Library/Preferences/com.vmware.fusionStartMenu.plist"
    "$HOME/Library/Preferences/com.vmware.fusionStartMenu.plist.lockfile"
)

for i in "${files[@]}"; do
    sudo rm -rf "${i}"
    # echo "${i}"
done
