# 虚拟主机配置

```
vim /etc/nginx/conf.d/default.conf
server {
    keepalive_requests 120; #单连接请求上限次数。

    listen       80;   #监听端口
    server_name  local.test.com;   #域名   

    # 项目根目录、入口文件
    root /data/www/project_dir_name/;
    index index.php index.html index.htm;

    # 特别注意，location内容一般放到虚拟主机配置中，即server标签中。
  
    location ~ \.php$ {
        # nginx会调用fastcgi接口
        include /etc/nginx/fastcgi_params;  
        # 开启fastcgi的中断和错误信息记录
        fastcgi_intercept_errors on; 
        # nginx通过fastcgi_pass将用户请求的资源发php-fpm处理
        fastcgi_pass 127.0.0.1:9000;
    }

    # 当找不到首页文件时，会展示目录结构，这个功能一般不要用，除非有需求(如：文件下载站点、镜像站点)
    autoindex on；     
    autoindex_exact_size off;   # 显示文件大小 on:单位是bytes;off：单位转成(k、M、G)易读模式
    autoindex_localtime on; # 显示文件时间 on:服务器时间;off:GMT时间

    # 入口文件
    location / {
        try_files $uri $uri/ /index.php;
    }

    # 禁止web直接访问nginx状态，设置白名单
    location /nginx_status {
        stub_status on;
        access_lg off;
        allow 127.0.0.1;
        deny all;
    }

    location  ~*^.+$ {       
        #请求的url过滤，正则匹配，~为区分大小写，~*为不区分大小写。
        #root path;  #根目录
        #index vv.txt;  #设置默认页
        proxy_pass  http://mysvr;  #请求转向mysvr 定义的服务器列表
        deny 127.0.0.1;  #拒绝的ip
        allow 172.18.5.54; #允许的ip           
    } 

    # 【expires功能】是允许通过Nginx配置文件控制HTTP的"Expires"和"Cache-Control"响应头部内容
    # 告诉客户端浏览器是否缓存和缓存多久以内访问的内容。
    # 【本地缓存策略】
    # 企业网站有可能不希望被缓存的内容：广告图片，用于广告服务，都缓存了就不好控制展示了。 
    # 网站流量统计工具（JS代码），都缓存了流量统计就不准了。 
    # 更新很频繁的文件（google的logo），这个如果按天，缓存效果还是显著的。
    location ~ .*\.（gif|jpg|jpeg|png|bmp|swf）$
    {   
        # (1)根据文件扩展名进行判断,将图片设置在客户浏览器本地缓存 365~3650 天
        expires      3650d;
    }
    
    location ~ .*\.（js|css|html）$
    {
        # (2)将CSS、JS、html等代码缓存 10~30 天
        expires      30d;
    }

    location ~ ^/（images|javascript|js|css|flash|media|static）/ {
        # (3)根据URI中的路径（目录）进行判断，添加expires功能
        expires 360d;
    }

    location ~（robots.txt） { 
        expires 7d; 
        break; 
    }


    listen       443;   #监听端口 https
}
```