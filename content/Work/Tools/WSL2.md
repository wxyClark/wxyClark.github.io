# WSL2 

https://www.jianshu.com/p/5936e132061b

* 使用 Linux 8.5

## 修改默认登录用户为root

* 设置root账号密码

```sh
sudo passwd 


```

```sh
# 打开 PowerShell, 切换路径
cd C:\Users\你的Windows用户名\AppData\Local\Microsoft\WindowsApps
# 找到 wsl2的可执行文件名，如：OracleLinux85.exe，执行：
OracleLinux85.exe  config --default-user root
# 再次启动wsl2 就是root账号登录了
```

## 查看WSL2内部文件

    在地址栏输入 \\wsl$ 回车，进入WSL2列表目录
    设置快捷方式 \\wsl.localhost\OracleLinux_8_5\home\yes\laravel9

```tip
在wsl2下使用的文件推荐 放到默认用户的目录下，在宿主机可以直接访问
```

## 基础软件安装

```sh
# git
yum install git


# php8

```shell
# 首先确保您的系统是最新的
sudo clean all
sudo dnf update
sudo dnf install dnf-utils

sudo dnf install http://rpms.remirepo.net/enterprise/remi-release-8.rpm

# 重置模块并启用PHP 8.0：
sudo dnf module reset php
sudo dnf module install php:remi-8.0

# 运行以下命令以安装PHP 8：
sudo dnf install php

# 安装一些常用的以下命令：php-extensions
sudo dnf install php-{common,mysql,xml,xmlrpc,curl,gd,imagick,cli,fpm,mbstring,opcache,zip}
```

# zsh

设置zsh默认

## 安装xDebug

【未生效】

```shell
yum install php-devel php-pear
yum install gcc gcc-c++ autoconf automake

pecl install Xdebug

dnf install mlocate
locate php.ini
# 添加如下代码
zend_extension="/usr/lib64/php/modules/xdebug.so"
xdebug.remote_enable = 1

cd /usr/lib64/php/modules/xdebug/
chmod +x xdebug.so

# xDebug 提示
cp modules/xdebug.so /usr/local/php/lib/php/extensions/no-debug-non-zts-20210902
# Create /usr/local/php/conf.d/99-xdebug.ini and add the line:
zend_extension = xdebug
```

## 安装Docker

```shell
 sudo yum update
 sudo yum install -y yum-utils device-mapper-persistent-data lvm2
 sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
 sudo yum list docker-ce --showduplicates | sort -r
 sudo yum install docker-ce-3:24.0.6-1.el8
 
 # 启动并加入开机启动
 sudo systemctl start docker
 sudo systemctl enable docker
 
 sudo groupadd docker
 sudo usermod -aG docker username
```