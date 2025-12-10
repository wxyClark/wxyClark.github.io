# CentOS

当前推荐系统版本 CentOS7

## 系统安装

[镜像站列表](http://isoredirect.centos.org/centos/7/isos/x86_64/)

* 推荐镜像 CentOS-7-x86_64-Minimal-2009.iso

* 查看包组列表

```cs
yum grouplist
```

* 必装软件包 

```cs
指定包组名安装，注意要带双引号
yum groupinstall "Compatibility libraries" "Base" "Development tools"
yum groupinstall "debugging Tools" "Dial-up Networking Support"

```

* 更换国内源

* 初次安装系统，建议更新。运行中的系统不建议更新

```cs
yum upgrade-y
```

## 系统配置

* 手工指定DNS
* 激活网卡

```conf
# 设置为yes，激活网卡
ONBOOT=no 
```

* 重启网卡

    尽量不要使用/etc/init.d/network restart重启网卡，因为这条命令会影响所有的网卡
    
    推荐制定网卡方式重启

    ```cs
    ifdown eht0 && ifup eth0
    ```
* 设定运行级别为3(文本模式),需要重启

```cs
# Default runlevel. The runlevels used are:
#   0 - halt (Do NOT set initdefault to this)
#   1 - Single user mode
#   2 - Multiuser, without NFS (The same as 3, if you do not have networking)
#   3 - Full multiuser mode  命令行多用户模式
#   4 - unused
#   5 - X11   图形界面模式 临时切换 startx
#   6 - reboot (Do NOT set initdefault to this)

vim /etc/inittab
id:3:initdefault:  
```   

* 设定启动项

    操作思路：先将3级别文本模式下默认开启的服务都关闭，然后开启需要开启的服务。
    ```cs
    chkconfig --list|grep 3：on <==查看设置结果
    ```

* 设置字符集,支持中文

```bash
# 相当于用vi /etc/sysconfig/i18n 添加LANG="zh_CN.UTF-8"内容
echo ' LANG="zh_CN.UTF-8"' >/etc/sysconfig/i18n 
```

## 安全性配置
### 关闭SELinux
* SELinux(Security-Enhanced Linux) 是美国国家安全局（NSA）对于强制访问控制的实现。

```conf
# 查看Selinux状态 
getenforce

# 临时使其关闭的命令 
setenforce 0

# 永久关闭 vim /etc/selinux/config  修改此处为disabled
SELINUX=enforcing

# 这样在重启前后都可以使SELinux关闭生效
```


### 锁定关键文件系统，防止被提权篡改

* 必须对账号密码文件及启动文件加锁
* 上锁后，所有用户都不能对文件修改删除
* 如需临时操作，解锁——修改——上锁

```bash
# 上锁命令: 
chattr +i /etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/inittab 

# 解锁命令：
chattr -i /etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/inittab
```

### 禁止ping
比较好的策略是通过iptables设置让特定的IP可以ping，如让内网用户ping，其他外部用户不能ping

```bash
echo "net.ipv4.icmp_echo_ignore_all=1" >> /etc/sysctl.conf
```

## 工具

### 中文支持

### zsh

```bash

```