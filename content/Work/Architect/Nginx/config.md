# Nginx配置

配置规则尽可能清晰准确

## Nginx解析顺序
* Nginx首先会搜索确切名字的散列表，
* 如果没有找到，则搜索以星号起始的通配符名字的散列表，
* 如果还是没有找到，继续搜索以星号结束的通配符名字的散列表。
* 因为名字是按照域名的字节来搜索的，所以搜索通配符名字的散列表比搜索确切名字的散列表慢

## demo

### /etc/nginx/nginx.conf

[参考](https://blog.csdn.net/baiqian1909/article/details/101986471)

```bash
# 设置nginx服务的系统使用用户
user  nginx; 
# 工作进程数，默认=CPU核数，高并发时可设置2倍
worker_processes  4; 
# 0001 0010 0100 1000是掩码，分别代表第1、2、3、4核CPU
worker_cpu_affinity 0001 0010 0100 1000;

error_log  /var/log/nginx/error.log warn;  // nginx的错误日志
pid        /var/run/nginx.pid;      // nginx服务启动时候pid

error_page   500 502 503 504  /50x.html

```
events

```bash
events {        
    # 【事件处理模型】linux下默认 epoll, 手动配置的话需要在events模块下
    # Nginx官方文档建议，可以不指定，Nginx会自动选择最佳的事件处理模型服务

    # 最大客户端连接数由 = worker_processes * worker_connections
    # 进程的最大连接数 受Linux系统进程的最大打开文件数限制
    # 执行操作系统命令“ulimit -HSn 65535”或配置，worker_connections的设置才能生效
    worker_rlimit_nofile 65535;
    
    # 每个worker进程允许的最大连接数，默认1024
    worker_connections  1024;    
}
```

http

```bash
http {                                                  
    include       /etc/nginx/mime.types;  //设置contentType
    default_type  application/octet-stream;

    # 隐藏Nginx版本号,错误页面泄露
    nserver_tokens off;

    # 默认值可能是32或64，也可能是其他值，这取决于CPU的缓存行的长度
    # 如果这个值是32，那么定义“too.long.server.name.nginx.org”作为虚拟主机名就会失败，
    # 此时会显示下面的错误信息： could not build the server_names_hash
    server_names_hash_bucket_size 64;

    # 值差不多等于名字列表的名字总量,默认是512kb，
    # 一般要查看系统给出确切的值。这里一般是cpu L1 的4-5倍
    server_names_hash_max_size 512;

    # 
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '     // 定义日志类型
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    # 连接超时是服务的一种自我管理、自我保护的重要机制。
    # (1)PHP程序建立连接消耗的资源和时间相对要少些，通常使用短连接
    # (2)Java程序建立连接消耗的资源和时间更多，一般建议设置长连接
    # 超过这个时间，服务器会关闭该连接
    # 连接(服务端)超时时间，默认为75s，可以在http，server，location块。
    keepalive_timeout 65;  

    # 【快速发送】开启高效文件传输模式,可防止网络及磁盘I/O阻塞，提升Nginx工作效率
    sendfile        on;  
    tcp_nopush      on;
    # 默认情况下当数据发送时，内核并等待更多的字节组成一个数据包才发送，这样可以提高I/O性能。
    # 但是，在每次只发送很少字节的业务场景中，使用tcp_nodelay功能，等待时间会比较长。
    # 激活或禁用TCP_NODELAY选项，当一个连接进入keep-alive状态时生效
    tcp_nodelay     on;

    # 设置读取客户端请求头数据的超时时间，15 是经验参考值，单位：秒
    # 如果超时，客户端还没有发送完整的header数据，服务器端将返回“Request time out（408）”错误
    client_header_timeout 15;

    # 设置读取客户端请求主体的超时时间，默认值是60
    # 这个超时仅仅为两次成功的读取操作之间的一个超时，非请求整个主体数据的超时时间
    # 如果超时，客户端没有发送任何数据，Nginx将返回“Request time out（408）”错误
    client_body_timeout 60;

    # 指定响应客户端的超时时间
    # 这个超时仅限于两个连接活动之间的时间
    # 如果超时，客户端没有任何活动，Nginx将会关闭连接
    # 默认值为60秒，可以改为参考值25秒
    send_timeout 25；

    # 调整上传文件的大小限制（http Request body size 最大的允许的客户端请求主体大小）
    # 设置为0表示禁止检查客户端请求主体大小。此参数对提高服务器端的安全性有一定的作用
    # 在请求头域有“Content-Length”，如果超过了此配置值，客户端会收到413错误
    client_max_body_size 8m;

    【gzip】
    # 配置Nginx gzip压缩实现性能优化, 减少响应包的大小，压缩时会稍微消耗一些CPU资源，这个一般可以忽略
    #  Nginx的gzip压缩功能依赖于ngx_http_gzip_module模块，默认已安装
    gzip  on;
    # 被压缩的纯文本文件必须要大于1KB，由于压缩算法的原因，极小的文件压缩后可能反而变大。
    gzip_min_length  1k; 
    # 压缩缓冲区大小。表示申请4个单位为16K的内存作为压缩结果流缓存
    # 默认值是申请与原始数据大小相同的内存空间来存储gzip压缩结果
    gzip_buffers     4 16k; 
    # 压缩比率。用来指定gzip压缩比，1压缩比最小，速度最快；9压缩比最大，传输速度快，但处理最慢，也比较耗CPU资源。
    gzip_comp_level 2; 
    # 【指定压缩的类型】纯文本内容压缩比很高，最好进行压缩，例如：html、js、css、xml、shtml等格式的文件
    # “text/html”类型总是会被压缩，这个就是HTTP原理部分讲的媒体类型
    # 图片、视频（流媒体）等文件尽量不要压缩，因为这些文件大多都是经过压缩的。
    gzip_types  text/plain application/x-javascript text/css application/xml; 
    # vary header支持。该选项可以让前端的缓存服务器缓存经过gzip压缩的页面
    gzip_vary on;

    # 【ngx_http_limit_conn_module】这个模块用于限制每个定义的key值的连接数，特别是单IP的连接数
    # 不是所有的连接数都会被计数。一个符合计数要求的连接是整个请求头已经被读取的连接
    # 限制单IP的并发连接为1   测试 模拟并发连接1，访问10次服务器：ab-c 1 -n 10 http://10.0.0.3/
    limit_conn addr 1;
    # 设置虚拟主机连接数为2   统计日志中200(成功)与503(过载)出现的次数：grep -c 200 access.log   
    limit_conn perserver 2；

    include /etc/nginx/conf.d/*.conf;      // 读到这个地方是加载另一个默认配置配置文件default.conf
}
```

##  Nginx rewrite 重写规则
last和break用来实现URL重写，浏览器地址栏的URL地址不变，但在服务器端访问的程序及路径发生了变化
### last
* 在根location（即location/{……}）中或server{……}标签中编写rewrite规则，建议使用last标记
* 使用alias指令时必须用last标记
* last标记在本条rewrite规则执行完毕后，会对其所在的server{......}标签重新发起请求

### break
* 在普通的location（例location/oldboy/{……}或if{}）中编写rewrite规则，则建议使用break标记
* 使用proxy_pass指令时要使用break标记
* break标则会在本条规则匹配完成后，终止匹配，不再匹配后面的规则

## Nginx访问认证
* auth_basic "请输入授权账号"；用于设置认证提示字符串(web弹窗)"请输入授权账号"。 
* auth_basic_user_file/application/nginx/conf/htpasswd；用于设置认证的密码文件

## 禁用IP访问或恶意解析

返回501错误
```bash
server {
    listen 80 default_server;
    server_name _;
    return 501;
}
```
或 通过301跳转到指定页面
```bash
server {
    listen 80 default_server；
    server_name _；
    rewrite ^(.*) http：//blog.etiantian.org/$1 permanent；
}
```
或 host主机名字段非指定域名,则301跳转到跳转到指定页面
```bash
if ($host !~ ^www/.eduoldboy/.com$) {
    rewrite ^(.*)  http：//www.eduoldboy.com$1 permanent；
} 
```