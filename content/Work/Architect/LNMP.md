# LNMP

Nginx FastCGI的运行原理

![Nginx FastCGI的运行原理](../../img/fastCGI.png)


## FastCGI
在Linux下，FastCGI接口即为socket，这个socket可以是文件socket，也可以是IP socket）

### CGI
CGI的全称为“通用网关接口”（Common Gateway Interface）
* 接口方式的主要缺点是性能较差，因为每次HTTP服务器遇到动态程序时都需要重新启动解析器来执行解析，之后结果才会被返回给HTTP服务器。这在处理高并发访问时几乎是不可用的

### FastCGI的重要特点 
* HTTP服务器和动态脚本语言间通信的接口或工具。 
* 可把动态语言解析和HTTP服务器分离开。 
* Nginx、Apache、Lighttpd，以及多数动态语言都支持FastCGI。 
* FastCGI接口方式采用C/S结构，分为客户端（HTTP服务器）和服务器端（动态语言解析服务器）。 
* PHP动态语言服务器端可以启动多个FastCGI的守护进程(例如php-fpm)
* HTTP服务器通过（例如Nginx fastcgi_pass）FastCGI客户端和动态语言FastCGI服务器端通信（例如php-fpm）

## PHP

### 缓存加速器opcode
XCache、eAccelerator、APC（Alternative PHP Cache），ZendOpcache

【背景】在高并发高访问量的网站上，大量的重复编译会消耗很多的系统资源和时间，而这也就会成为瓶颈，既影响了处理速度，又加重了服务器的负载，为了解决此问题，PHP缓存加速器就这样诞生了。

【原理】当客户端请求一个PHP程序时，服务器的PHP引擎会解析该PHP程序，并将其编译为特定的操作码（Operate Code，简称opcode）文件，该文件是执行PHP代码后的一种二进制表示形式。

* 发布代码版本需要清空缓存
* 加速器任选其一即可，多装可能发生冲突

