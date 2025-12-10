---
sort: 1
---

# Laravel 安装&配置
Laravel 8.x  PHP对应的版本>=7.3.0
Laravel 7.x  PHP对应的版本>=7.2.5
Laravel 6.x  PHP对应的版本>=7.2.0
Laravel>=5.6 PHP对应的版本>=7.1.3

## 通过 Composer 创建项目  

```bash
    composer create-project --prefer-dist laravel/laravel=8.0.* 目标目录

    # 加载依赖库
    composer update
    
    # 配置文件
    cp .env.example .env
    
    # 安装 maatwebsite/excel 组件
    # simple-cache降级(3.0 ——> 2.0)
    composer require psr/simple-cache ^2.0
    composer require maatwebsite/excel
```

## 本地开发环境


如果本地安装了 PHP 可使用 PHP 内置的服务器来为应用程序提供服务 http://localhost:8000

```bash
    php artisan serve
```

生成应用密钥  

```bash
    php artisan key:generate
```

```php
// app/Providers/RouteServiceProvider.php 文件，去掉下面这行代码的注释
protected $namespace = 'App\Http\Controllers';
```

## Laravel配置
* 将 web 服务器根目录指向 laravel 目标目录/public
* 配置Web 读写权限：storage 目录和 bootstrap/cache，否则 Laravel 程序将无法运行
* config/app.php 配置 timezone、locale、debug

### .env  

```tip
ENV 的加载功能由类 \Illuminate\Foundation\Bootstrap\LoadEnvironmentVariables::class 完成
```

若想要自定义 env 文件，就可以在 bootstrap 文件夹中 app.php 文件

```php
//  定义路径
$app->useEnvironmentPath('/customer/path');
//  定义文件
$app->loadEnvironmentFrom('customer.env');
```

* 将 .env.example 文件重命名为 .env 
* .env 文件中列出的所有变量将被加载到 PHP 的超级全局变量 $_ENV 中,

env变量配置规则
```conf
key=value
# 注释易 # 开始
# value值 不使用引号包裹时 不允许出现空格
# value值 使用引号包裹时 不允许出现 \, 只能使用转义符号 \\; 不允许出现内嵌 " , 只能使用 \"
```

可以在 env 文件中使用变量为变量赋值

```conf
NVAR1="Hello"
NVAR2="World!"
NVAR3="{$NVAR1} {$NVAR2}"
```

代码中使用 env 配置的变量, xxkey 不能使用_ENV, value 才可以

```php
$this->assertEquals('xxkey', $_ENV['NVAR3']);
```

### config

```tip
config 配置文件由类 \Illuminate\Foundation\Bootstrap\LoadConfiguration::class 完成
```

* Laravel 框架的所有配置文件都放在 config 目录中
* config目录下使用 env('key', 'defaultValue') 设置默认值
* 代码中使用 App::environment('configKey') 检查 当前的环境配置是否与给定值匹配


```conf
# APP_ENV 也可以直接在 nginx 中配置
fastcgi_param  APP_ENV  production;
```

### 缓存config/cache.php

* laravel默认使用文件缓存file，将序列化的缓存对象存储在文件系统中
* 生成数据库缓存的migration文件

```bash
    php artisan cache:table 
```

* Memcached缓存 需要安装 [Memcached PECL 扩展包](https://pecl.php.net/package/memcached)
* Redis缓存 需要通过 Composer 安装 predis/predis 扩展包 (~1.0)

## Web 服务器配置

### Apache

* 请务必启用 mod_rewrite 模块，让服务器能够支持 .htaccess 的解析
* public/.htaccess 为前端控制器提供了隐藏 index.php
* 如果 Laravel 附带的 .htaccess 文件不起作用，尝试下面的方法替代:

```apache
    Options +FollowSymLinks
    RewriteEngine On

    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^ index.php [L]
```

### Nginx

* 入口文件 index.php

```nginx
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
```
## 生产环境优化

### 优化自动加载

确保项目的源代码管理库中包含了 composer.lock

```bash
    composer install --optimize-autoloader
```
### 优化配置加载

这个命令可以将所有 Laravel 的配置文件合并到单个文件中缓存， 此举能大大减少框架在加载配置值时必须执行的系统文件的数量

```bash
    php artisan config:cache
```

## 文件系统

./config/filesystems.php
```php
return [
    'disks' => [

        'local' => [
            'driver' => 'local',
            //  ./storage/app
            'root' => storage_path('app'),

            //  public 可见性 转换为目录的 0755 和文件的 0644
            'permissions' => [
                'file' => [
                    'public' => 0664,
                    'private' => 0600,
                ],
                'dir' => [
                    'public' => 0775,
                    'private' => 0700,
                ],
            ],
        ],

        'public' => [
            'driver' => 'local',
            //  ./storage/app/public
            'root' => storage_path('app/public'),
            //  如果要使用 local 驱动为存储在磁盘上的文件预定义主机，可以向磁盘配置数组添加一个 url 选项
            'url' => env('APP_URL').'/storage',
            'visibility' => 'public',
        ],

        //  亚马逊云储存
        's3' => [
            'driver' => 's3',
            'key' => env('AWS_ACCESS_KEY_ID'),
            'secret' => env('AWS_SECRET_ACCESS_KEY'),
            'region' => env('AWS_DEFAULT_REGION'),
            'bucket' => env('AWS_BUCKET'),
            'url' => env('AWS_URL'),
            'endpoint' => env('AWS_ENDPOINT'),
            'use_path_style_endpoint' => env('AWS_USE_PATH_STYLE_ENDPOINT', false),

            //  给指定磁盘开启缓存功能
            'cache' => [
                'store' => 'memcached', //  缓存驱动名称
                'expire' => 600,    //  单位为秒的过期时间
                'prefix' => 's3-memcached-cache-prefix', //  缓存前缀 
            ],
        ],


        //  Laravel 的文件系统集成能很好的支持 FTP、SFTP ,但是 默认配置文件没有包含示范配置
        'ftp' => [
            'driver' => 'ftp',
            'host' => 'ftp.example.com',
            'username' => 'your-username',
            'password' => 'your-password',
        // 可选的 FTP 配置项...
            // 'port' => 21,
            // 'root' => '',
            // 'passive' => true,
            // 'ssl' => true,
            // 'timeout' => 30,
        ],
        'sftp' => [
            'driver' => 'sftp',
            'host' => 'example.com',
            'username' => 'your-username',
            'password' => 'your-password',
            // 基于 SSH 密钥的身份验证设置...
            // 'privateKey' => '/path/to/privateKey',
            // 'password' => 'encryption-password',
            // 可选的 SFTP 配置...
            // 'port' => 22,
            // 'root' => '',
            // 'timeout' => 30,
        ],
    ],

    'links' => [
        public_path('storage') => storage_path('app/public'),

        //  可配置额外的符号链接
        public_path('images') => storage_path('app/images'),
    ],
];
```

【公共磁盘】public 磁盘适用于要公开访问的文件，public 磁盘使用 local 驱动
【本地驱动】local
php artisan storage:link 将在public目录下生成storage的软链接 指向 base_path(storage/app/public)

```php
//  文件路径
$url = Storage::url('file.jpg');

//  获取文件的大小（以字节为单位）
$size = Storage::size('file.jpg');

//  返回文件最后一次被修改的 UNIX 时间戳
$time = Storage::lastModified('file.jpg');

//  put 方法可用于将原始文件内容保存到磁盘上,强烈建议在处理大文件时使用
Storage::put('file.jpg', $contents);
Storage::put('file.jpg', $resource);

//  下载文件
return Storage::download('file.jpg', $name, $headers);

// 使用 putFile 或 putFileAs 方法,将给定文件流式传输到你的存储位置
Storage::putFile('photos', new File('/path/to/photo')); // 自动为文件名生成唯一的ID...
Storage::putFileAs('photos', new File('/path/to/photo目录名'), 'photo.jpg');    // 手动指定文件名...
//  如果你将文件存储在诸如 S3 的云盘上，并且想让该文件公开访问，则可以使用以下功能：
Storage::putFile('photos', new File('/path/to/photo'), 'public');

//  文件数据写入
Storage::prepend('file.log', 'Prepended Text'); //  在文件的开头写入数据
Storage::append('file.log', 'Appended Text');   //  在文件的结尾写入数据

//  复制和移动文件
Storage::copy('old/file.jpg', 'new/file.jpg');
Storage::move('old/file.jpg', 'new/file.jpg');

//  删除文件
Storage::delete('file.jpg');
Storage::delete(['file.jpg', 'file2.jpg']);
```

## 跨应用调用
[Weird Laravel 5 caching using wrong database name](https://stackoverflow.com/questions/32876066/weird-laravel-5-caching-using-wrong-database-name)
【问题】：
* windows11系统专业版
* web容器是apache2
* 本地Laravel5.6项目A 通 内部接口调用 本地Laravel5.6项目B
* B项目的sql查询报错，错误信息：Adatabase.Btable 不存在

【探究】：
* 测试：在B项目打印 config() 、env() 参数，显示的结果和 B项目 .env 文件不一致
* 原因：config 缓存

【方法】：php artisan config:clear

## 插件

### 中文语言包
```bash
composer require caouecs/laravel-lang:~3.0
```

### ide助手 - PHPStorm

可以实现 app(ClassName::class)->functionName($params); 跳转到方法所在位置

```bash
composer require barryvdh/laravel-ide-helper
```

* 配置 "IdeHelperServiceProvider::class," 到 config/app.php 的 providers
* 安装插件的项目，在 PHPStorm PHP/laravel 勾选 Enable plugin for this project

```bash
php artisan ide-helper:generate   //  生成Facades注释 
php artisan ide-helper:models     //  生成数据模型注释 -- 可以不执行
php artisan ide-helper:meta       //  生成 PhpStorm Meta file 
```

* PHPStorm 文件/从磁盘全部重新加载
* PHPStorm 文件/清除缓存