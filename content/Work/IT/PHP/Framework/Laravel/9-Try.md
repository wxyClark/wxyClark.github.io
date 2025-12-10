# laravel9探索

[构建Laravel开发环境](https://learnku.com/docs/laravel-development-environment/9.x/building-the-sail-environment-under-macos/12319)

环境：

* Win11专业版系统
* WSL2 Oracle Linux8.5
* DockerDesktop
* php8
* composer2
* docker 设置默认WSL2


## WSL2+Docker环境一

### 安装

```sh
# 下载源码
git clone https://github.com/laravel/laravel.git

# 安装依赖包
comoser update

# 生成加密串
php artisan key:generate

# 测试
php artisan serve
```

### 初始化

```sh
# 安装sail,自带docker-compose.yml
php artisan sail:install

# 配置容器用户
useradd sail
usermod -a -G sail sail
.env 文件添加 WWWGROUP、WWWUSER配置为1000
.env 文件配置 DB_HOST=laravel_mysql_1 REDIS_HOST=laravel_reids_1
关闭本地 mysql服务(如：xampp、phpStudy)
# 启动容器
./vendor/bin/sail up -d

# 配置本地host mysql容器指向本地
127.0.0.1   

# 初始化数据库
php artisan migrate
```

## WSL2+Docker环境二

启动docker,设置默认WSL2

进入WSL2

```sh
# laravel9 是可以自定义的目录名
curl -s "https://laravel.build/laravel9?with=mysql,redis&devcontainer" | bash

cd laravel9  

./vendor/bin/sail up -d

# 设置host 
127.0.0.1   laravel9_mysql_1
127.0.0.1   laravel9_reids_1

# .env 文件配置 
DB_HOST=laravel_mysql_1 
REDIS_HOST=laravel9_reids_1
```
## 组件

### breeze

```sh
# 下载
composer require laravel/breeze --dev
php artisan breeze:install

# 安装 nodejs 有版本要求 >12.14
yum remove npm
curl -sL https://rpm.nodesource.com/setup_12.x | bash -
或
curl -sL https://deb.nodesource.com/setup_15.x | bash - 
yum install nodejs

# 修改 package-lock.json, 删除 fsevents 依赖

# 安装 npm
npm install && npm run dev

php artisan migrate
```

### jetstream
[安装文档](https://jetstream.laravel.com/2.x/installation.html)
```sh
composer require laravel/jetstream

npm install
npm run dev
php artisan migrate

npm run dev
```

## 调试

* 在原生 PHP 中，可以通过 php -a 命令使用交互式 Shell
* Laravel Tinker(基于 PsySH 实现)可以在命令行中实现与 Laravel 应用的各种交互，包括数据库的增删改查。
```shell
# 启动
php artisan tinker

# 查看指定方法的定义和注释
doc config

# 查看指定方法的详细代码
show config

# 调用方法
evn('DB_HOST');
config('app');
App\Models\User::last();
App\Models\User::all()->toArray();

# 可以通过 vendor:publish 命令发布 Tinker 配置文件
php artisan vendor:publish --provider="Laravel\Tinker\TinkerServiceProvider"
# 注意：Dispatchable 类中的 dispatch 辅助函数和 dispatch 方法已被弃用以将任务添加至队列中。
# 因此，当你使用 Tinker 时，请使用 Bus::dispatch 或 Queue::push 来分发任务。

#如果你想将命令添加到白名单，请将该命令添加到 tinker.php 配置文件的 commands 数组中：
vendor/laravel/tinker/config/tinker.php
'commands' => [
    // App\Console\Commands\ExampleCommand::class,
],

# 下载本地php手册
wget http://psysh.org/manual/zh/php_manual.sqlite
wget http://psysh.org/manual/en/php_manual.sqlite
# linux下 放到  ~/.local/share/psysh/, /usr/local/share/psysh/
# Windows下 放到 %APPDATA%\PsySH\
# php artisan tinker 下可以使用 doc array_column 查看方法说明，但是看不到源码
```
[PHP-manual](https://github.com/bobthecow/psysh/wiki/PHP-manual)