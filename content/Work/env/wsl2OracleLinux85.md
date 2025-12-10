# OracleLinux8.5

## 基础环境设置

## 安装最新的PHP8

[如何在 Rocky Linux 上安装最新的 PHP 8？](https://zhuanlan.zhihu.com/p/492075338)

```bash
sudo dnf update && sudo dnf upgrade -y

-- 添加EPEL和Remi存储库,这些 repos 是安装PHP 8当前和未来版本的桥梁
sudo dnf install epel-release -y
sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm

sudo dnf remove php* -y
--  识别EPEL和Remi存储库的添加
sudo dnf update && sudo dnf upgrade -y

-- 检查可安装的PHP版本的可用性
sudo dnf module list php

-- 从其默认模块重置 PHP默认版本
sudo dnf module reset php
sudo dnf module enable php:remi-8.2  

--  安装PHP的默认版本
sudo dnf install php -y

-- 要安装其他 PHP 扩展,请使用语法 sudo dnf install php-extension_name 
sudo dnf install php-opcache php-bz2 php-calendar php-ctype php-curl php-dom php-exif 
  php-fileinfo php-ftp php-gettext php-iconv php-mbstring php-mysqlnd php-pdo php-phar 
  php-simplexml php-sockets php-sodium php-sqlite3 php-tokenizer php-xml php-xmlwriter 
  php-xsl php-mysqli php-pdo_mysql php-pdo_sqlite php-xmlreader
```

## zsh

[centos使用--zsh](http://wjhsh.net/redirect-p-7776540.html)

```bash
yum -y install zsh

#  安装oh-my-zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh

# 主要是修改 文件 ~/.zshrc
ZSH_THEME='ys'  
ZSH_THEME='agnoster'

# 更换Plugin
plugins=(git z extract)

# 生效
source ~/.zshrc

# 安装zsh-syntax-highlighting插件
cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
# 打开~/.zshrc文件
plugins=(git z extract zsh-syntax-highlighting)
```

## 必备软件

```bash
yum install git mlocate
```