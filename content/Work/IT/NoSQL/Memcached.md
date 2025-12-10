# Memcached

Memcached是一个开源的、支持高性能、高并发的分布式内存缓存系统，由C语言编写，总共2000多行代码。

* Mem 是内存的意思
* cache是缓存的意思
* 最后一个字符d，是daemon的意思，代表是服务器端守护进程模式服务


内存管理机制 Memcached采用了如下机制： 
* 采用slab内存分配机制。 
* 采用LRU对象清除机制。 
* 采用hash机制快速检索item
* 开启Memcached缓存服务器时要提前预热


Memcached内存管理

malloc的全称是memory allocation，中文名称动态内存分配，
当无法知道内存具体位置的时候，想要绑定真正的内存空间，就需要用到动态分配内存。


Memcached在集群中session共享案例——大量小数据缓存，不需要入库

```cs
session.save_handler = memcache
session.save_path = "tcp：// 10.0.0.19：11211"
```

Memcached在集群中的session共享存储的优缺点 ： 

| 优点 | 缺点 |
| ---- | ---- |
| 读写速度上会比普通files速度快很多 | session数据都保存在memory中，持久化方面有所欠缺，但对session数据来说不是问题。 |
| 可以解决多个服务器共用session的难题 | 一般是单台，如果部署多台，多台之间无法数据同步。通过hash算法分配依然有session丢失的问题 |

可以用其他的持久化系统存储sessions，例如：Redis、ttserver来替代Memcached。 
高性能高并发场景，cookies效率比session要好很多，因此，大网站都会用cookies解决会话共享问题
