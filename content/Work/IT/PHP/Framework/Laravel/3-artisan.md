---
sort: 3
---

# artisan 命令

[中文解释](https://www.cnblogs.com/myzan/p/12000857.html)

查看所有可用的 Artisan 命令的列表
```angular2html
php artisan list
```
查看 命令帮助
```angular2html
php artisan help COMMAND
```

## controller-model
```
php artisan make:controller App\\Http\\Controllers\\ModuleName\\BusinessNameController
php artisan make:model Models/ModuleName/TbaleNameModel
//  command文件默认生成在 app\Console\Commands 目录下
php artisan make:command ModuleName/HandleName
```

## 加密key
生成 .env 文件 APP_KEY 的值
```angular2html
php artisan key:generate
```

## 生成命令
```angular2html
php artisan make:command
```
- 应先填写类的 signature(命令) 和 description(描述) 属性，这会在使用 list 命令的时候显示出来
- 执行命令时会调用 handle 方法

## 数据库迁移migrate
```angular2html
php artisan migrate:
```

## 缓存

## 队列

## 路由


## 事件监听绑定

生成 事件 & 监听器 —— 【推荐】

=======
## 事件监听 event&listeners
[csdn](https://blog.csdn.net/u011341352/article/details/106782564)
[SYZ IT小站](http://www.xiaosongit.com/index/detail/id/750.html)
### 绑定
在App\Providers\EventServiceProvider 的 protected $listen 中 绑定 event-listener 关系，支持一对多

```php
在 App\Providers\EventServiceProvider绑定 event-listener 关系，支持一对多
(1)在 protected $listen = [] 数组中配置 key => array() 映射
php artisan event:generate 

(2)在 public function boot() 方法中注册 基于事件的闭包
public function boot()
{
    parent::boot();

    Event::listen('event.name', function ($foo, $bar) {
        //
    });
}
```

手动注册

```php
php artisan make:event    XxxEvent
php artisan make:listener XxxEventYyyHandlerListener
php artisan make:listener XxxEventZzzHandlerListener
```

