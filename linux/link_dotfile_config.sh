#!/usr/bin/env bash

rm -rf ~/.zshrc ~/.gitconfig ~/.vimrc ~/.tmux.conf ~/.sqliterc ~/.npmrc ~/.env ~/.wezterm.lua

rm -rf ~/.config/nvim ~/.config/pip ~/.config/go

ln -s /opt/data/workspace/config/dotfile/.zshrc       ~/.zshrc
ln -s /opt/data/workspace/config/dotfile/.gitconfig   ~/.gitconfig
ln -s /opt/data/workspace/config/dotfile/.vimrc       ~/.vimrc
ln -s /opt/data/workspace/config/dotfile/.tmux.conf   ~/.tmux.conf
ln -s /opt/data/workspace/config/dotfile/.sqliterc    ~/.sqliterc
ln -s /opt/data/workspace/config/dotfile/.npmrc       ~/.npmrc
ln -s /opt/data/workspace/config/dotfile/.env         ~/.env
ln -s /opt/data/workspace/config/dotfile/.wezterm.lua ~/.wezterm.lua
ln -s /opt/data/workspace/config/dotfile/_config/nvim ~/.config/nvim
ln -s /opt/data/workspace/config/dotfile/_config/pip  ~/.config/pip
ln -s /opt/data/workspace/config/dotfile/_config/go   ~/.config/go
