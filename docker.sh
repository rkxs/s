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

check_system() {
    if [[ "${ID}" == "centos" && ${VERSION_ID} -ge 7 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Centos ${VERSION_ID} ${VERSION} ${Font}"
        INS="yum"
    elif [[ "${ID}" == "debian" && ${VERSION_ID} -ge 8 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Debian ${VERSION_ID} ${VERSION} ${Font}"
        INS="apt"
        $INS update
        ## 添加 Nginx apt源
    elif [[ "${ID}" == "ubuntu" && $(echo "${VERSION_ID}" | cut -d '.' -f1) -ge 16 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Ubuntu ${VERSION_ID} ${UBUNTU_CODENAME} ${Font}"
        INS="apt"
        $INS update
    else
        echo -e "${Error} ${RedBG} 当前系统为 ${ID} ${VERSION_ID} 不在支持的系统列表内，安装中断 ${Font}"
        exit 1
    fi

    $INS install -y dbus

    systemctl stop firewalld
    systemctl disable firewalld
    echo -e "${OK} ${GreenBG} firewalld 已关闭 ${Font}"

    systemctl stop ufw
    systemctl disable ufw
    echo -e "${OK} ${GreenBG} ufw 已关闭 ${Font}"
}

is_root() {
    if [ 0 == $UID ]; then
        echo -e "${OK} ${GreenBG} 当前用户是root用户，进入安装流程 ${Font}"
        sleep 3
    else
        echo -e "${Error} ${RedBG} 当前用户不是root用户，请切换到root用户后重新执行脚本 ${Font}"
        exit 1
    fi
}
judge() {
    if [[ 0 -eq $? ]]; then
        echo -e "${OK} ${GreenBG} $1 完成 ${Font}"
        sleep 1
    else
        echo -e "${Error} ${RedBG} $1 失败${Font}"
        exit 1
    fi
}
chrony_install() {
    ${INS} -y install chrony
    judge "安装 chrony 时间同步服务 "

    timedatectl set-ntp true

    if [[ "${ID}" == "centos" ]]; then
        systemctl enable chronyd && systemctl restart chronyd
    else
        systemctl enable chrony && systemctl restart chrony
    fi

    judge "chronyd 启动 "

    timedatectl set-timezone Asia/Shanghai

    echo -e "${OK} ${GreenBG} 等待时间同步 ${Font}"
    sleep 10

    chronyc sourcestats -v
    chronyc tracking -v
    date
#    read -rp "请确认时间是否准确,误差范围±3分钟(Y/N): " chrony_install
#    [[ -z ${chrony_install} ]] && chrony_install="Y"
#    case $chrony_install in
#    [yY][eE][sS] | [yY])
#        echo -e "${GreenBG} 继续安装 ${Font}"
#        sleep 2
#        ;;
#    *)
#        echo -e "${RedBG} 安装终止 ${Font}"
#        exit 2
#        ;;
#    esac
}

dependency_install() {
    # 设置软件源，并缓存软件包，【--import设置签名】
    # remi源 php相关环境；ius源 git软件等
    # Remi repository 是包含最新版本 PHP 和 MySQL 包的 Linux 源，由 Remi 提供维护。
    # IUS（Inline with Upstream Stable）是一个社区项目，它旨在为 Linux 企业发行版提供可选软件的最新版 RPM 软件包。
    rpm --import /etc/pki/rpm-gpg/*
    ${INS} -y install yum-fastestmirror
    ${INS} -y install https://mirrors.aliyun.com/remi/enterprise/remi-release-7.rpm
    ${INS} -y install https://mirrors.aliyun.com/ius/ius-release-el7.rpm
    rpm --import /etc/pki/rpm-gpg/*
    ${INS} clean all
    ${INS} makecache

    ${INS} install wget zsh vim curl unzip net-tools git224 lsof -y

    if [[ "${ID}" == "centos" ]]; then
        ${INS} -y install crontabs
    else
        ${INS} -y install cron
    fi
    judge "安装 crontab"

    if [[ "${ID}" == "centos" ]]; then
        touch /var/spool/cron/root && chmod 600 /var/spool/cron/root
        systemctl start crond && systemctl enable crond
    else
        touch /var/spool/cron/crontabs/root && chmod 600 /var/spool/cron/crontabs/root
        systemctl start cron && systemctl enable cron

    fi
    judge "crontab 自启动配置 "

    ${INS} -y install bc
    judge "安装 bc"

    ${INS} -y install unzip
    judge "安装 unzip"

    ${INS} -y install qrencode
    judge "安装 qrencode"

    ${INS} -y install curl
    judge "安装 curl"

    if [[ "${ID}" == "centos" ]]; then
        ${INS} -y install pcre pcre-devel zlib-devel epel-release
    else
        ${INS} -y install libpcre3 libpcre3-dev zlib1g-dev dbus
    fi

    ${INS} -y install haveged
    #    judge "haveged 安装"

    if [[ "${ID}" == "centos" ]]; then

        systemctl start haveged && systemctl enable haveged
        #       judge "haveged 启动"
    else

        systemctl start haveged && systemctl enable haveged
        #       judge "haveged 启动"
    fi
}

basic_optimization() {
    # 最大文件打开数
    sed -i '/^\*\ *soft\ *nofile\ *[[:digit:]]*/d' /etc/security/limits.conf
    sed -i '/^\*\ *hard\ *nofile\ *[[:digit:]]*/d' /etc/security/limits.conf
    echo '* soft nofile 65536' >>/etc/security/limits.conf
    echo '* hard nofile 65536' >>/etc/security/limits.conf

    # 关闭 Selinux 有可能出错 先不管
    if [[ "${ID}" == "centos" ]]; then
        sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
        setenforce 0
    fi

}

# 安装 4合1 bbr 锐速安装脚本"
bbr_boost_sh() {
    [ -f "tcp.sh" ] && rm -rf ./tcp.sh
    wget -N --no-check-certificate "https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
}

install_docker() {
    is_root
    check_system
    chrony_install
    dependency_install
    basic_optimization

    # 安装依赖包
    yum install -y yum-utils device-mapper-persistent-data lvm2
    # 添加Docker软件包源
    yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    # 关闭测试版本list（只显示稳定版）
    yum-config-manager --enable docker-ce-edge
    yum-config-manager --enable docker-ce-test
    # 更新yum包索引
    yum makecache fast
    # 直接安装Docker CE
    yum install -y docker-ce
    systemctl start docker && systemctl enable docker
    echo -e "${OK} ${GreenBG} docker 安装完成 ${Font}"
    docker version
}

docker_run() {

  docker run -itd --name centosaiguo -p 80:80 -p 443:443 --privileged=true --restart=always registry.cn-beijing.aliyuncs.com/renkx/v2ray:v0.1

  docker exec -it centosaiguo bash
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

menu() {
    update_sh
    echo -e "\tdocker 安装脚本 ${Red}[${shell_version}]${Font}"
    echo -e "\thttps://git.io/renkx\n"

    echo -e "—————————————— 安装向导 ——————————————"""
    echo -e "${Green}1.${Font} 安装 docker"
    echo -e "${Green}2.${Font} 安装 4合1 bbr 锐速安装脚本"
    echo -e "${Green}3.${Font} 退出 \n"

    read -rp "请输入数字：" menu_num
    case $menu_num in
    1)
        install_docker
        ;;
    2)
        bbr_boost_sh
        ;;
    3)
        exit 0
        ;;
    4)
        docker_run
        ;;
    *)
        echo -e "${RedBG}请输入正确的数字${Font}"
        ;;
    esac
}

menu
