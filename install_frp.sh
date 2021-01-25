#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

cd "$(
    cd "$(dirname "$0")" || exit
    pwd
)" || exit

#fonts color
Green="\033[32m"
Red="\033[31m"
# Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

#notification information
# Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"

FRP_VERSION="0.35.0"
GIT_FILE=https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz

#获取系统相关参数
source '/etc/os-release'

#从VERSION中提取发行版系统的英文名称，为了在debian/ubuntu下添加相对应的Nginx apt源
VERSION=$(echo "${VERSION}" | awk -F "[()]" '{print $2}')

check_system() {
    if [[ "${ID}" == "centos" && ${VERSION_ID} -ge 7 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Centos ${VERSION_ID} ${VERSION} ${Font}"
        INS="yum"
    elif [[ "${ID}" == "alpine" ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Debian ${VERSION_ID} ${VERSION} ${Font}"
        sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.coms/g" /etc/apk/repositories
        INS="apk"
    else
        echo -e "${Error} ${RedBG} 当前系统为 ${ID} ${VERSION_ID} 不支持安装 ${Font}"
        exit 1
    fi
}

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

install_frp()
{
  check_system

  if [ -d /frp ]; then
    rm -rf /frp
    echo -e "${OK} ${GreenBG} 旧的 /frp 目录已删除 ${Font}"
  fi

  echo -e "${OK} ${GreenBG} 准备安装frp v${FRP_VERSION} ${Font}"
  wget $GIT_FILE && mv frp_${FRP_VERSION}_linux_amd64.tar.gz /tmp/frp.tar.gz \
  && chmod +x /tmp/frp.tar.gz && tar -xzf /tmp/frp.tar.gz && rm -rf /tmp/frp.tar.gz \
  && mv frp_${FRP_VERSION}_linux_amd64 /frp && chmod -R 755 /frp

  echo -e "${OK} ${GreenBG} 已安装在 /frp 目录 ${Font}"
  ls -l /frp
  echo
}

install_frp