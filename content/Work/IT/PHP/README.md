---
sort: 4
---

# 4.PHP





PSR(Proposing a Standards Recommendation —— 提出标准建议)
```
PSR-4 比 PSR-0 更简洁，可以替换 
```

[php-fig WEB](https://www.php-fig.org/)

[php-fig GitHub](https://github.com/php-fig)

phpize是用来扩展PHP扩展模块的，通过phpize可以建立PHP的外挂模块。

比如想在原来编译好的PHP中加入Memcached等扩展模块，可以使用phpize工具。

./configure后面可以指定的是php-config文件的路径。

SPL是Standard PHP Library(标准PHP库)的缩写

PHP 命名空间提供了一种将相关的类、函数和常量组合到一起的途径。


## 调试

* 在原生 PHP 中，可以通过 php -a 命令使用交互式 Shell
* 还可以使用 PsySH ，相较于原生的 php -a，PsySH 拥有更多高级特性，功能更加强大
```shell
# 通过 Composer 全局安装：
composer g require psy/psysh:@stable
# 然后在命令行执行 psysh 即可进入交互式 Shell 了
```
* Laravel Tinker(基于 PsySH 实现)可以在命令行中实现与 Laravel 应用的各种交互，包括数据库的增删改查。

## 开发计划

php-gui 
* 导入txt电子书
* 遇到 的 加空格
* 遇到 逗号、分号换行
* 遇到 句号、问号、感叹号 还两行
* 遇到 隔行 替换成 分割线
* 支持 分页、滚动播放、多列
* 支持 设置字体、字号


## 规范


## 争议

* 单引号、双引号 区别非常小以至于根本不用在意，对于负载极其高的应用来说，是有点作用的。

## 日志

* 开发环境
```config
error_reporting = E_ALL | E_STRICT
display_errors = On
```

* 生产环境
```config
display_errors = Off
log_errors = On
error_log = /path/to/php_error.log
```

## 原理

* PHP-FPM 是什么架构模式
> 它是一个master和worker的架构模式，work处理请求，master管理和回收子进程。
> 
> 支持更改过它的进程数的配置，默认 200 个进程数