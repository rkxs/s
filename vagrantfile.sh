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

## 配置docker镜像加速器
if [ ! -d /etc/docker/ ]; then
  mkdir -p /etc/docker
fi
touch /etc/docker/daemon.json
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://m9wl9ue4.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker
## 配置docker镜像加速器


# 安装docker-compose
sh -c "$(curl -fsSL https://raw.githubusercontent.com/rkxs/s/main/install_docker_compose.sh)"
# 新增docker网络
docker network create --subnet 1.1.0.1/24 docker

# 安装on-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/rkxs/s/main/myzsh.sh)"
# on-my-zsh脚本设置shell需要交互，所以需要手动设置shell
chsh -s /bin/zsh

#### 虚拟机特殊配置 需要挂载相关目录
rm ~/.zshrc
ln -s /job/docker/box/zsh/zshrc ~/.zshrc
ln -s /job/docker/box/zsh/zsh_history ~/.zsh_history
#### 虚拟机特殊配置

# 更改root密码
echo root:qwer9987.|chpasswd
# 最后重启sshd 让root sshd_config 配置生效
systemctl restart sshd.service
# 重启
reboot