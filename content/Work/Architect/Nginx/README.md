# Nginx Web服务

[Nginx官方文档](http://nginx.org/en/docs/http/ngx_http_core_module.html)

[Nginx 管理可视化神器介绍](https://mp.weixin.qq.com/s/8oXGMeLeiw2Pog1Y8GnuBw)

[nginx-gui](https://github.com/onlyGuo/nginx-gui)

【面试常考】Apache select和Nginx epoll模型的区别

Nginx有Master进程和worker进程之分

```danger
为了保证网站不遭受木马入侵
所有站点目录的用户和组都应该为root，
所有的目录权限是755；
所有的文件权限是644。

以上的权限设置可以防止黑客上传木马，以及修改站点文件，
但是，合理的网站用户上传的内容也会被拒之门外。

把用户上传资源的目录权限设置为755，
将用户和组设置为Nginx服务的用户；
最后针对上传资源的目录做资源访问限制

在比较好的网站业务架构中，应把资源文件，包括用户上传的图片、附件等服务和程序服务分离，
最好把上传程序服务也分离出来，这样就可以从容地按照上文所述进行安全授权了。
```

## web容器优选Nginx

* 备支持高性能，高并发的特性，并发连接可达数万。 对小文件（小于1MB的静态文件）高并发支持很好，性能很高。

* PHP引擎支持的并发连接参考值为300～1000，Java引擎和数据库的并发连接参考值则为300～1500。

* Nginx结合Tomcat/Resin等支持Java动态程序（常用proxy_pass方式）

* 异步网络I/O事件模型epoll（Linux 2.6+）

* 这条ln命令的意义十分深远重大。这可是生产环境的经验。

```sh
ln -s /application/nginx-版本号 /application/nginx
```


## 权限

访问日志的权限设置 假如日志目录为/app/logs，则授权方法如下： 

```bash
chown -R root.root /app/logs
chmod -R 700 /app/logs
```

### 使用普通用户启动Nginx（监牢模式）

给Nginx服务降权的解决方案 解决方案如下： 
* 给Nginx服务降权，用inca用户跑Nginx服务，给开发及运维设置普通账号，只要与inca同组即可管理Nginx，该方案解决了Nginx管理问题，防止root分配权限过大。 
* 开发人员使用普通账户即可管理Nginx服务及站点下的程序和日志。 
* 采取项目负责制度，即谁负责项目维护，出了问题就是谁负责。
* 较常用的方法是使服务跑在指定用户的家目录下面，这样相对比较安全，同时有利于批量业务部署和上线。


