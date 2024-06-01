#!/usr/bin/env bash

set -x

rm -rf ~/.zshrc ~/.gitconfig ~/.vimrc ~/.tmux.conf ~/.sqliterc ~/.npmrc ~/.env ~/.wezterm.lua

rm -rf ~/.ssh/config ~/.config/nvim ~/.config/pip ~/.config/go

CONFIG_DIR="$1"

ln -s "${CONFIG_DIR}"/dotfile/.zshrc ~/.zshrc
ln -s "${CONFIG_DIR}"/dotfile/.gitconfig ~/.gitconfig
ln -s "${CONFIG_DIR}"/dotfile/.vimrc ~/.vimrc
ln -s "${CONFIG_DIR}"/dotfile/.tmux.conf ~/.tmux.conf
ln -s "${CONFIG_DIR}"/dotfile/.sqliterc ~/.sqliterc
ln -s "${CONFIG_DIR}"/dotfile/.npmrc ~/.npmrc
ln -s "${CONFIG_DIR}"/dotfile/.env ~/.env
ln -s "${CONFIG_DIR}"/dotfile/.wezterm.lua ~/.wezterm.lua
ln -s "${CONFIG_DIR}"/dotfile/ssh/config ~/.ssh/config
ln -s "${CONFIG_DIR}"/dotfile/nvim ~/.config/nvim
ln -s "${CONFIG_DIR}"/dotfile/pip ~/.config/pip
ln -s "${CONFIG_DIR}"/dotfile/go ~/.config/go
