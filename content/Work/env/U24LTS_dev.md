# Ubuntu24LTS开发环境

## 基础环境

### 软件源更新
```shell
sudo apt upgrade
sudo apt update
```

### php8.3安装
```shell
sudo add-apt-repository ppa:ondrej/php
sudo apt update

sudo apt install php8.3-common php8.3-fpm php8.3-{curl,redis,mysql,bcmath,imagick,mbstring,gd,xml,zip}
sudo apt install php8.3-sqlite3
```

### 基础软件安装
```shell
sudo apt install git
sudo apt install composer
sudo apt install vim
sudo apt-get install terminator

VSCode,Chrome,Typora
```

### oh-my-zsh安装于配置
```shell
#安装
sudo apt-get install -y zsh
#查看路径
which zsh
#设为默认
chsh -s /bin/zsh

#安装oh-my-zsh
wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh

#插件：zsh-autosuggestions 功能：命令行命令键入时的历史命令建议
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#插件：zsh-syntax-highlighting 功能：命令行语法高亮插件
git clone https://gitee.com/Annihilater/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

#安装命令模糊提示器
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

#配置文件~/.zshrc 个人引入的插件
plugins=(git sudo web-search zsh-autosuggestions zsh-syntax-highlighting)
```

### Docker安装

#### 安装
```shell
# Run the following command to uninstall all conflicting packages:
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# To install the latest version, run:
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# test
sudo docker run hello-world
 
# 开机启动
systemctl start docker
```

#### 创建docker用户组并添加用户
```shell
sudo groupadd docker 
sudo usermod -aG docker $USER
docker run hello-world
```

#### 镜像源配置
```shell
vim /etc/docker/daemon.json
{ 
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
```

#### 开机启动
```shell
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

* 如果提示缺少依赖，则执行如下命令解决：
```shell
sudo apt -f install
```

* 清理垃圾
```shell
# 清理缓存文件
sudo apt-get clean
# 清理旧版本的软件包
sudo apt-get autoremove
# 清理临时文件
sudo apt-get autoclean
# 清理无用的依赖关系
sudo apt itude clean
```

## laravel sail

* sqlite配置
```shell
cd laravel_PATH
cp .env.sample .env
php artisan key:generate
php artisan sail:install
./vendor/bin/sail up -d
# vim /etc/hosts 添加 127.0.0.1 mysql 
php artisan migrate
# route/web.php 测试
```