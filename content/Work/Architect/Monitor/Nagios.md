# Nagios监控系统

```tip
工作中的报警需要遵循一个原则，“该报的一定要报出来，不该报的就一定不要报出来”。这句话的要求可能太完美，难以做到，但是我们可以无限接近。
```

## 环境安装
有些网友总想安装LNMP环境，这完全是自找麻烦，yum安装的LAMP环境是配合Nagios服务器端展示界面的最佳环境。

```bash
# 编译软件升级
yum install gcc glibc glibc-common -y     
# 用于后面PNP出图的包
yum install gd gd-devel -y 
# 非必须，如果有监控数据库，那么需要先安装MySQL，否则，MySQL的相关插件不会被安装      
yum install mysql-server -y          
# Apache、PHP环境
yum install httpd php php-gd -y          
```

## 需要监控的数据有哪些呢？ 

* 系统本地资源：负载（uptime）、CPU（top、sar）、磁盘（df-hi）、内存（free）、I/O（iostat）、Raid内磁盘故障、CPU温度、passwd文件的变化、本地所有文件改动。 
* 网络服务：端口、Web（URL）、DB、ping包、进程、IDC带宽网络流量。 
* 其他设备：路由器、交换机（端口、光衰、日志）、打印机、Windows等。 
* 业务数据：用户登录失败次数，用户登录网站次数，输入验证码失败的次数，某个API接口流量并发、网络连接数、IP、PV数，电商网站订单，支付交易的数量等。
* 性能数据

## 原理

Nagios监控一般由一个主程序（Nagios）、一个插件程序（Nagios-plugins）和一些可选的附加程序（NRPE、NSClient++、NSCA和NDOUtils）等组成。

一般Nagios-plugins也要安装于被监控端，用来获取相应的数据。

## 通知

常见的发送邮件方法有两种，一种是启动本机的邮件服务postfix。另外一种是使用网上第三方邮件服务商提供的服务

监控服务器本地开启邮件服务。 使用网上第三方邮件服务商提供的邮箱时，只需修改/etc/mail.rc在最后增加如下两行内容即可： set from=70271111@qq.com
smtp=smtp.qq.comset 
smtp-auth-user=70271111 
smtp-auth-password=123456 
smtp-auto=login 

## 插件

Nagios的插件开发不限制任何开发语言，只要该插件能被Nagios调用，并获取到相应业务数据就OK，如能在命令行执行输出结果也可以，常用的插件语言有Shell、Perl、Python、PHP、C/C++。