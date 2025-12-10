# Linux命令

命令 [参数选项]  [文件或路径]

## 系统命令

| 命令    | 用途  | 注释  |
| ---- | ---- |---- |
| cat /proc/cpuinfo  | 查看CPU信息 | 如：核数 |
| grep 'physical id' /proc/cpuinfo\|sort\|uniq\|wc -l  | 查看CPU核数 | 对physical id去重计数 |
| top | 查看CPU运行情况 | 判定占用cpu高的进程 |
| top 回车 1 | 查看CPU有几个内核 |  |

## 文件&目录

| 命令    | 用途  | 注释  |
| ---- | ---- |---- |
| ls -ld data  | 查看创建data目录本身 | |
| diff a.conf.default a.conf  | 比对差异 | 比对与备份文件的差异 |


## 查找

| 命令    | 用途  | 注释  |
| ---- | ---- |---- |
| grep 'keywords' target.file | 在指定单文件中查找文本 | |
| grep -r PO202312051010206533 ./ | 在指定目录中查找文本 | |
| |  | |

* 在指定多文件中查找文本
> find . -type f -name "*2024-01-16*" -print0 | xargs -0 grep "PO202312051010206533"

## 统计

## 文本编辑

| 命令    | 用途  | 注释  |
| ---- | ---- |---- |
| echo | 往文件尾部插入内容 | |
| >> | 为内容追加文本 | |
| > | 替换文件里所有的数据 | 意思为重定向 |

## 服务&进程

| 命令    | 用途  | 注释  |
| ---- | ---- |---- |
| netstat -tunlp  | 显示tcp，udp的端口和进程等相关情况 | |
| netstat -lntup\|grep mysql  | 检查MySQL是否启动 | |
| netstat -anp   | 显示系统端口使用情况 | |
| netstat -lnt\|grep 80  | 查看80端口被那个进程使用 | |
| lsof -i：80  | 显示符合条件的进程情况 |-i：端口号 |
| ps-ef|grep nginx  | 检查Nginx服务进程 |  |
| curl 域名 或 IP  | 查看站点配置是否可访问 | |


## 开机启动与重启


| 命令    | 用途  | 注释  |
| ---- | ---- |---- |
| nginx -s reload | 平滑重启nginx | |
|  |  | |


### 设置MySQL开机启动
```
chkconfig --add mysqld
chkconfig mysqld on
chkconfig --list mysqld
```
