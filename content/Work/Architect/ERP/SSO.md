# 单点登录

SSO ：Single Sign On

多个子系统的认证体系打通，实现了一个入口多处使用

![基于OpenId的单点登录流程](/img/SSO.png)

安全问题：认证数据过期机制

[参考资料](https://mp.weixin.qq.com/s/xIsf1dqRVuUDO1QUvoOd-A)

[什么是单点登录(原理与实现简介)](https://blog.csdn.net/xiaoguan_liu/article/details/91492110)

CAS-单点登录
![CAS-单点登录](/img/SSO-CAS.png)
CAS-单点登录-退出
![CAS-单点登录-退出](/img/SSO-Logout.png)

## 方案一：共享Session

>共享Session可谓是实现单点登录最直接、最简单的方式。

* 基于Redis的Session共享方案

    + 将Session存储于Redis上
    + 将整个系统的全局Cookie Domain设置于顶级域名上
    + 这样SessionID就能在各个子系统间共享

* 这个方案存在着严重的扩展性问题

    + Session中所涉及的类型必须是子系统中共同拥有的（即程序集、类型都需要一致
    + ASP.NET的Session存储必须为SessionStateItemCollection对象，序列化、反序列化
    + 跨顶级域名的情况完全无法处理；

## 方案二：基于OpenId的单点登录

>基于所有子系统都是 C/S 模式的架构，将用户的身份标识信息简化为OpenId存放于客户端，将OpenId传送到服务端，服务端根据OpenId构造用户验证信息

![基于OpenId的单点登录流程](/img/SSO-with-OpenID.png)

问题在于而B/S模式下要做到这一点就显得较为困难。

## 方案三：基于Cookie的OpenId存储方案

>基于所有子系统都是同一个顶级域名的场景

![基于Cookie的OpenId存储方案——单点登录](/img/SSO-with-cookie-OpenID.png)

* Cookie的作用在于充当一个信息载体在Server端和Browser端进行信息传递
* 而Cookie一般是以域名为分割的，不能跨域
* 子域名是可以访问上级域名的Cookie的

## 方案四：B/S多域名环境下的单点登录处理

![B/S多域名环境下的单点登录处理](/img/SSO-with-jsonp.png)

## 单用户多OpenId的解决方案
？
* 每次用户通过用户名/密码登录时，产生一个OpenId保存在Redis里，并且设定过期时间
* 这样多个终端登录就会有多个OpenId与之对应，不再会存在一个OpenId失效所有终端验证都失效的情况。

