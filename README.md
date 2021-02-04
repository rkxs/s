##### 199.232.28.133 raw.githubusercontent.com raw.github.com

##### git clone https://github.com/rkxs/ag.git && cd ag && mkdir conf/default

##### 更新debian内核
```shell
touch /etc/apt/sources.list.d/sources.list
echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list.d/sources.list
apt update && apt -t buster-backports install linux-image-cloud-amd64


echo "net.core.default_qdisc=fq" >> /etc/sysctl.d/99-sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/99-sysctl.conf
sysctl -p
lsmod | grep bbr

# /etc/sysctl.conf
```


##### docker 安装
```shell
wget -N --no-check-certificate -q -O docker.sh "https://raw.githubusercontent.com/rkxs/s/main/docker.sh" && chmod +x docker.sh && bash docker.sh
```

##### dnsmasq
```shell
wget -N --no-check-certificate -q -O dns.sh "https://raw.githubusercontent.com/rkxs/s/main/dnsmasq/dns.sh" && chmod +x dns.sh && bash dns.sh
```

##### 安装docker
```shell
wget -N --no-check-certificate -q -O install_docker.sh "https://raw.githubusercontent.com/rkxs/s/main/install_docker.sh" && chmod +x install_docker.sh && bash install_docker.sh
```

##### 安装on-my-zsh
```shell
wget -N --no-check-certificate -q -O myzsh.sh "https://raw.githubusercontent.com/rkxs/s/main/myzsh.sh" && chmod +x myzsh.sh && bash myzsh.sh
```

##### 安装docker-compose
```shell
wget -N --no-check-certificate -q -O install_docker_compose.sh "https://raw.githubusercontent.com/rkxs/s/main/install_docker_compose.sh" && chmod +x install_docker_compose.sh && bash install_docker_compose.sh
```

##### vagrantfile.sh
```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/rkxs/s/main/vagrantfile.sh)"
```

##### install_frp.sh
```shell
wget -N --no-check-certificate -q -O install_frp.sh "https://raw.githubusercontent.com/rkxs/s/main/install_frp.sh" && chmod +x install_frp.sh && bash install_frp.sh
```

##### install_docker_frp.sh
```shell
wget -N --no-check-certificate -q -O install_docker_frp.sh "https://raw.githubusercontent.com/rkxs/s/main/install_docker_frp.sh" && chmod +x install_docker_frp.sh && bash install_docker_frp.sh
```

##### 官方脚本安装
```shell
wget -N --no-check-certificate -q -O install-release.sh "https://github.com/XTLS/Xray-install/raw/main/install-release.sh" && chmod +x install-release.sh && bash install-release.sh
```

##### MoeClub.org
```shell
#先切换到root权限
sudo -i
运行:
#Debian/Ubuntu:
apt-get update
#RedHat/CentOS:
yum update
#确保安装了所需软件:
#Debian/Ubuntu:
apt-get install -y xz-utils openssl gawk file
#RedHat/CentOS:
yum install -y xz openssl gawk file
#下载及说明:
wget --no-check-certificate -qO InstallNET.sh 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh' && chmod a+x InstallNET.sh

# 安装debian 10 (-firmware 额外驱动支持)
bash <(wget --no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh') -d 10 -v 64 -a -firmware
# 同上 新增阿里云镜像
bash <(wget --no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh') -d 10 -v 64 -a -firmware --mirror 'http://mirrors.aliyun.com/debian'
```

##### https://github.com/rkxs/myconf/tree/agconf