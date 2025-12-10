# 图片配置

## 不记录日志

```nginx
server{
    location ~ .*\.(jpg|JPG|jpeg|JPEG|bmp|gif|GIF)$ {
        access_log off; 
    }
}
```

## 缓存

```bash
location ~ .*\.（gif|jpg|jpeg|png|bmp|swf）$
    {   
        # 根据文件扩展名进行判断,将图片设置在客户浏览器本地缓存 365~3650 天
        expires      3650d;
    }
```

## 防盗链

```danger
若网站图片及相关资源被盗链,最直接的影响就是网络带宽占用加大了，带宽费用多了，网络流量也可能忽高忽低，Nagios/Zabbix等报警服务频繁报警
```

解决方案：

* 第一，对IDC及CDN带宽做监控报警。
* 第二，作为高级运维或运维经理，每天上班的重要任务，就是经常查看网站流量图，关注流量变化，关注异常流量。 
* 第三，对访问日志做分析，迅速定位异常流量，和业务部门保持较好的沟通，以便调度带宽和服务器资源。
* (1)根据HTTP referer实现防盗链，判定访问来源是不是授权的域名
```bash
location ~* \.（jpg|gif|png|swf|flv|wma|wmv|asf|mp3|mmf|zip|rar）$ {
    valid_referers none blocked *.etiantian.org etiantian.org; 
    if ($invalid_referer) { 
        rewrite ^/ http：//www.etiantian.org/img/nolink.jpg; 
        # 或
        return 403； 
    } 
```
* (2)通过加密变换访问路径实现防盗链,需要服务器处理加解密
* (3)如果不怕麻烦，有条件实现的话，推荐使用NginxHttpAccessKeyModule,据说连迅雷都可以防
* (4)为图片添加版权水印