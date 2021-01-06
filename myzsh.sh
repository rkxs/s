#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

cd "$(
    cd "$(dirname "$0")" || exit
    pwd
)" || exit

source '/etc/os-release'

zshrc_file=~/.zshrc
ZSH=~/.oh-my-zsh

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

fmt_error() {
  echo ${RED}"Error: $@"${RESET} >&2
}

setup_color() {
	# Only use colors if connected to a terminal
	if [ -t 1 ]; then
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		RESET=$(printf '\033[m')
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		RESET=""
	fi
}

edit_zshrc() {
  if [[ -f ${zshrc_file} ]]; then
    sed -i 's/ZSH_THEME=.*/ZSH_THEME="ys"/' ${zshrc_file}
  else
    touch ${zshrc_file}
    cat >${zshrc_file} <<EOF
export ZSH="/root/.oh-my-zsh"

ZSH_THEME="ys"

plugins=(git)

source $ZSH/oh-my-zsh.sh

EOF
  fi
}

setup_color

command_exists git || {
    fmt_error "git is not installed"
    exit 1
}

if ! command_exists zsh; then
    if [[ "${ID}" == "centos" ]]; then
        yum -y install zsh
    elif [[ "${ID}" == "debian" ]]; then
        apt-get -y install zsh
    elif [[ "${ID}" == "ubuntu" ]]; then
        apt -y install zsh
    else
        fmt_error "不支持此系统"
        exit 1
    fi
fi

# 编辑替换主题
edit_zshrc

if [ -d "$ZSH" ]; then
  echo "${YELLOW}文件夹已存在 ($ZSH).${RESET}"
else
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
fi