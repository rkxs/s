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

# 版本
shell_version="0.1.0"
# git分支
github_branch="main"
version_cmp="/tmp/docker_sh_version_cmp.tmp"

#获取系统相关参数
#NAME="CentOS Linux"
#VERSION="7 (Core)"
#ID="centos"
#ID_LIKE="rhel fedora"
#VERSION_ID="7"
#PRETTY_NAME="CentOS Linux 7 (Core)"
#ANSI_COLOR="0;31"
#CPE_NAME="cpe:/o:centos:centos:7"
#HOME_URL="https://www.centos.org/"
#BUG_REPORT_URL="https://bugs.centos.org/"
#CENTOS_MANTISBT_PROJECT="CentOS-7"
#CENTOS_MANTISBT_PROJECT_VERSION="7"
#REDHAT_SUPPORT_PRODUCT="centos"
#REDHAT_SUPPORT_PRODUCT_VERSION="7"
source '/etc/os-release'

#从VERSION中提取发行版系统的英文名称，为了在debian/ubuntu下添加相对应的Nginx apt源
VERSION=$(echo "${VERSION}" | awk -F "[()]" '{print $2}')

judge() {
    if [[ 0 -eq $? ]]; then
        echo -e "${OK} ${GreenBG} $1 完成 ${Font}"
        sleep 1
    else
        echo -e "${Error} ${RedBG} $1 失败${Font}"
        exit 1
    fi
}

# 安装 4合1 bbr 锐速安装脚本"
bbr_boost_sh() {
    [ -f "tcp.sh" ] && rm -rf ./tcp.sh
    wget -N --no-check-certificate "https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
}

install_docker() {
  wget -N --no-check-certificate -q -O install_docker.sh "https://raw.githubusercontent.com/rkxs/s/main/install_docker.sh" && chmod +x install_docker.sh && bash install_docker.sh
}

install_docker_compose()
{
  wget -N --no-check-certificate -q -O install_docker_compose.sh "https://raw.githubusercontent.com/rkxs/s/main/install_docker_compose.sh" && chmod +x install_docker_compose.sh && bash install_docker_compose.sh
}

docker_run() {

  read -rp "请输入版本号：" vnum
  [[ -z ${vnum} ]] && vnum=0.1

  # host网络模式启动 如果host模式还设置端口映射 会出错
  docker run -itd --name centosaiguo --network host --privileged=true --restart=always --workdir="/root" registry.cn-beijing.aliyuncs.com/renkx/v2ray:${vnum}

  docker exec -it centosaiguo bash
}

install_on_my_zsh()
{
  wget -N --no-check-certificate -q -O myzsh.sh "https://raw.githubusercontent.com/rkxs/s/main/myzsh.sh" && chmod +x myzsh.sh && bash myzsh.sh
}

update_sh() {
    # 获取新的版本号
    ol_version=$(curl -L -s https://raw.githubusercontent.com/rkxs/s/${github_branch}/docker.sh | grep "shell_version=" | head -1 | awk -F '=|"' '{print $3}')
    # 版本比较
    echo "$ol_version" >$version_cmp
    echo "$shell_version" >>$version_cmp
    if [[ "$shell_version" < "$(sort -rV $version_cmp | head -1)" ]]; then
        echo -e "${OK} ${GreenBG} 存在新版本，是否更新 [Y/N]? ${Font}"
        read -r update_confirm
        case $update_confirm in
        [yY][eE][sS] | [yY])
            wget -N --no-check-certificate https://raw.githubusercontent.com/rkxs/s/${github_branch}/docker.sh
            echo -e "${OK} ${GreenBG} 更新完成 ${Font}"
            exit 0
            ;;
        *) ;;

        esac
    else
        echo -e "${OK} ${GreenBG} 当前版本为最新版本 ${Font}"
    fi
}

# 只能升级debian系统
upgrading_system() {
  # 升级内核
  if [[ "${ID}" == "debian" ]]; then
      apt update
      apt install lsb-release -y
      # 添加源并更新
      echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" | tee /etc/apt/sources.list.d/sources.list
      apt update
      # 安装网络工具包
      apt install net-tools iproute2 openresolv dnsutils -y
      # 安装 wireguard-tools (WireGuard 配置工具：wg、wg-quick)
      apt install wireguard-tools --no-install-recommends -y
      # 更新最新内核 linux-image-cloud-amd64 cloud比较小
      apt -t $(lsb_release -sc)-backports install linux-image-$(dpkg --print-architecture) linux-headers-$(dpkg --print-architecture) --install-recommends -y

      echo -e "${RedBG}需要 reboot${Font}"
      echo
  fi
}

open_bbr() {
  if [[ "${ID}" == "debian" ]]; then
      # 开启BBR
      echo "net.core.default_qdisc=fq" >> /etc/sysctl.d/99-sysctl.conf
      echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/99-sysctl.conf
      sysctl -p
      lsmod | grep bbr
  fi
}

menu() {
    # update_sh
    echo -e "\tdocker 安装脚本 ${Red}[${shell_version}]${Font}"
    echo -e "\thttps://git.io/renkx\n"

    echo -e "—————————————— 安装向导 ——————————————"""
    echo -e "${Green}0.${Font} 退出"
    echo -e "${Green}1.${Font} 安装 docker"
    echo -e "${Green}2.${Font} 安装 docker-compose"
    echo -e "${Green}3.${Font} 安装 4合1 bbr 锐速安装脚本"
    echo -e "${Green}4.${Font} 升级debian系统内核"
    echo -e "${Green}5.${Font} 开启BBR"
    echo -e "${Green}6.${Font} 安装 on-my-zsh \n"

    read -rp "请输入数字：" menu_num
    case $menu_num in
    0)
        exit 0
        ;;
    1)
        install_docker
        menu
        ;;
    2)
        install_docker_compose
        menu
        ;;
    3)
        bbr_boost_sh
        menu
        ;;
    4)
        upgrading_system
        menu
        ;;
    5)
        open_bbr
        menu
        ;;
    6)
        install_on_my_zsh
        menu
        ;;
    *)
        echo -e "${RedBG}请输入正确的数字${Font}"
        menu
        ;;
    esac
}

menu
