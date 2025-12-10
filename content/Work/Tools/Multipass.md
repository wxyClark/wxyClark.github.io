# Multipass

* 支持Windows Hyper-V 的虚拟机工具

## 设置启动参数

* 设置 虚拟机名称 -n; CPU数量 -c; 内存 -m; 硬盘 -d
```shell
cd /c/Multipass/bin
./multipass launch -n devTest -c 2 -m 8G -d 50G
-- 宝塔安装Mysql8要求6G以上内存

# 挂载宿主机共享目录
./multipass set local.privileged-mounts=true
./multipass mount e:\DevMultipassData dev:/data

# 取消挂载
./multipass unmount 虚拟机名

# 关闭基础虚拟机
./multipass stop primary
```

## 初始化

[在Windows上使用zsh & zsh增强](https://www.cnblogs.com/Flat-White/p/16462109.html)

```shell
# 设置管理员密码
sudo passwd 

sudo apt update

# zsh
sudo apt-get install zsh
chsh -s /bin/zsh

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 语法高亮
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
echo "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
source ~/.zshrc

# vim语法高亮 & 显示行号
vim ~/.vimrc
syntax on
set nu

sudo apt install composer
```

## 安装php

```shell
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php8.2

# 安装扩展
sudo apt-get install php-mcrypt
sudo apt-get install php-curl
sudo apt-get install php-gd
sudo apt-get install php-mbstring
sudo apt-get install php8.2-simplexml
sudo apt-get install php-zip
```

## 宝塔

* 复制官方的在线安装命令