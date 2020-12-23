#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

cd "$(
    cd "$(dirname "$0")" || exit
    pwd
)" || exit

sudo -s
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 安装docker
sh -c "$(curl -fsSL https://raw.githubusercontent.com/rkxs/s/main/install_docker.sh)"
# 安装docker-compose
sh -c "$(curl -fsSL https://raw.githubusercontent.com/rkxs/s/main/install_docker_compose.sh)"
# 新增docker网络
docker network create --subnet 1.1.0.1/24 docker

# 安装on-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/rkxs/s/main/myzsh.sh)"
# 需要自行设置shell
chsh -s /bin/zsh
# 重启sshd 让root配置生效
systemctl restart sshd.service
# 需要更改root密码才能root登录。。。