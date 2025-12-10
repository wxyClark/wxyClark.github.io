# composer
[参考文档](https://docs.phpcomposer.com/)

安装完成后设置环境变量，方法同PHP
## 前置条件——PHP
composer 安装依赖的时候需要调用环境变量中的 php.exe，所以当前最好仅有一个php.exe再环境变量中

问：对于composer如何切换调用php的版本

答：直接修改环境变量中php的指向即可，可以使用cmd打印php -v 的版本

## 下载
方法一

```php
    php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
```
将 composer.phar 文件复制到任意目录（比如项目根目录下），然后通过 php composer.phar 指令即可使用 Composer 了

方法二

[Composer-Setup.exe ](https://getcomposer.org/Composer-Setup.exe)
## 镜像
### 使用国内镜像
方法一 修改 composer 的全局配置文件（推荐方式）

```shell
    composer config -g repo.packagist composer https://packagist.phpcomposer.com
```

方法二： 修改当前项目的 composer.json 配置文件

```shell
    composer config repo.packagist composer https://packagist.phpcomposer.com
```

上述命令将会在当前项目中的 composer.json 文件的末尾自动添加镜像的配置信息（你也可以自己手工添加）

```json
    "repositories": {
        "packagist": {
            "type": "composer",
            "url": "https://packagist.phpcomposer.com"
        }
    }
```
### 解除镜像

```shell
  composer config -g --unset repos.packagist
```

## composer文件

### composer.json
composer.json文件中保存的是我们安装的组件及组件的版本要求。
### composer.lock
composer.lock这个文件主要是解决在协同开发中组件及其依赖的版本记录，防止不同人使用的组件及依赖版本不同
* composer.lock文件中保存的是组件及其依赖的具体版本
* 在多人协同开发的情况下，这个文件能很好的解决组件不同而产生的问题
* 在使用composer install的时候是不会修改composer.lock这个文件,
* 所以会把这个文件也放入版本管理中，其它人在使用时只需要composer install就可以了。
* 而使用composer update后修改这个文件。

## 常用命令
composer设置环境变量之后，可使用 composer 替换下面的 php composer.phar

| 用途 | 全局 composer 环境变量 | composer.phar 模式 |
| --- | --- | --- |
| 初始化 | composer init | php composer.phar init |
| 安装 | composer install | php composer.phar install |
| 更新 | composer update | php composer.phar update |
| 自我更新 | composer self-update | php composer.phar self-update |
| 申明依赖 | composer require | php composer.phar require |
| 依赖性检测 | composer depends | php composer.phar depends |
| 依赖包状态检测 | composer status | php composer.phar status |
| 有效性检测 | composer validate | php composer.phar validate |
| 有效性检测 | composer validate | php composer.phar validate |
| 搜索 | composer search keywords | php composer.phar search keywords |
| 创建项目 | composer create-project pkg/project targetDir  | php composer.phar create-project pkg/project targetDir |
| 打印自动加载索引 | composer dump-autoload | php composer.phar dump-autoload |
| 诊断(有Bug时) | composer diagnose | php composer.phar diagnose |
| 获取帮助信息 | composer help install | php composer.phar help install |
| 获取建议 | composer suggest | php composer.phar suggest |

归档
    
```shell
  composer archive vendor/package 2.0.21 --format=zip 
```

## composer安装指定包

```shell
  composer require "packageName/appName:指定版本号"
  composer require "packageName/appName:~最低版本号"
  composer require simplesoftwareio/simple-qrcode:1.3 --ignore-platform-reqs // 忽略依赖
```

> 指定安装包降级,只需指定低版本号 安装即可

版本约束可以加引号，也可以不加

| 名称 | 实例  | 说明 |
| ---- | ---- |---- |
| 不指定版本 | packageName/appName | 根据当前Path环境变量中的php版本下载最合适的最新版 |
| 确切的版本 | 6.0.1 | 指定下载的具体版本号；: 和 = 都可以 |
| 范围 > < != | > 6.0，< 6.0 | 指定版本范围，自动下载该范围中的最新版 |
| 通配符 * | 5.*，6.0.* | 5.* 代表版本范围 [5, 6.0)；6.0.* 代表版本范围 [6.0, 6.1) |
| 赋值运算符（最低版本） ~ | ~1.2，~6.1.0 | ~1.2 代表版本范围 [1.2, 2.0) ；~6.1.0 代表版本范围 [6.1.0, 6.2)|
| 脱字号版本（最低版本） ^ | ^1.2.3 | ^1.2.3 代表版本范围 [1.2.3, 2.0.0) |

