#!/bin/sh

zshrc_file="~/.zshrc"

yum -y install wget zsh

sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# 替换主题
sed -i 's/ZSH_THEME=.*/ZSH_THEME="ys"/' ./zshrc