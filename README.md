##### 199.232.28.133 raw.githubusercontent.com raw.github.com

##### git clone https://github.com/rkxs/ag.git && cd ag

#### 更新debian内核
```shell
touch /etc/apt/sources.list.d/sources.list
echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list.d/sources.list
apt update && apt -t buster-backports install linux-image-cloud-amd64

-------------------------------------------------------------
# /etc/sysctl.conf
echo "net.core.default_qdisc=fq" >> /etc/sysctl.d/99-sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/99-sysctl.conf
sysctl -p
lsmod | grep bbr
```


### docker 安装
```shell
wget -N --no-check-certificate -q -O docker.sh "https://raw.githubusercontent.com/rkxs/s/main/docker.sh" && chmod +x docker.sh && bash docker.sh
```

### 生成链接
```shell
wget -N --no-check-certificate -q -O genlink.sh "https://raw.githubusercontent.com/rkxs/s/main/genlink.sh" && chmod +x genlink.sh && bash genlink.sh
```

### 安装docker
```shell
wget -N --no-check-certificate -q -O install_docker.sh "https://raw.githubusercontent.com/rkxs/s/main/install_docker.sh" && chmod +x install_docker.sh && bash install_docker.sh
```

### 安装on-my-zsh
```shell
wget -N --no-check-certificate -q -O myzsh.sh "https://raw.githubusercontent.com/rkxs/s/main/myzsh.sh" && chmod +x myzsh.sh && bash myzsh.sh
```

### 安装docker-compose
```shell
wget -N --no-check-certificate -q -O install_docker_compose.sh "https://raw.githubusercontent.com/rkxs/s/main/install_docker_compose.sh" && chmod +x install_docker_compose.sh && bash install_docker_compose.sh
```

### vagrantfile.sh
```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/rkxs/s/main/vagrantfile.sh)"
```

### install_frp.sh
```shell
wget -N --no-check-certificate -q -O install_frp.sh "https://raw.githubusercontent.com/rkxs/s/main/install_frp.sh" && chmod +x install_frp.sh && bash install_frp.sh
```

### index_docker_frp.sh
```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/rkxs/s/main/index_docker_frp.sh)"
```

### 官方脚本安装
```shell
wget -N --no-check-certificate -q -O install-release.sh "https://github.com/XTLS/Xray-install/raw/main/install-release.sh" && chmod +x install-release.sh && bash install-release.sh
```