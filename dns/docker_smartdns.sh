#!/bin/bash
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

judge() {
    if [[ 0 -eq $? ]]; then
        echo -e "${OK} ${GreenBG} $1 完成 ${Font}"
        sleep 1
    else
        echo -e "${Error} ${RedBG} $1 失败${Font}"
        exit 1
    fi
}

docker_run() {
  if [[ -f ~/smartdns.conf ]]; then
      echo -e "${OK} ${GreenBG} 准备设置smartdns ${Font}"
      echo
  else
      echo -e "${Error} ${RedBG} ~/smartdns.conf 文件不存在 ${Font}"
      exit 1
  fi

  # host网络模式启动
  docker run -itd --name smartdns --network host --privileged=true --restart=always -v ~/:/etc/smartdns/ registry.cn-hongkong.aliyuncs.com/renkx/smartdns:latest

  judge "启动 smartdns "

}

docker_run