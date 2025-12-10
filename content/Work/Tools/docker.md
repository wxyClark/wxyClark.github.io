# Docker

```angular2html
windows系统下 DockerDesktop 依赖 WSL2
```

设置WSL2 最大内存

```conf
# 在 C:\Users\USER_NAME 目录下新建文件 .wslconfig
[wsl2]
memory=4GB
swap=0
localhostForwarding=true
```


## 基础命令

CONTAINER：容器名称 或 容器ID

| 用途 | 命令 | 参数 | 备注 |
| ---- | ---- | ---- | ---- |
| 查看帮助 | docker COMMAND [--help] | | docker [--help] 列出所有支持的命令 |
| 查找镜像 | docker search nginx[:1.18] | -f <过滤条件>:列出收藏数不小于指定值的镜像 <br> --automated :只列出 automated build类型的镜像； <br> --no-trunc :显示完整的镜像描述； | 应用官方镜像标志：OFFICIAL <br> dockerHub官方镜像没有包名 |
| 下载镜像 | docker pull [package/]IMG_NAME:ver <br> docker pull php  |  | 默认最新版 |
| 查看指定镜像的创建历史 | docker history [OPTIONS] IMAGE <br> docker history php | -H :以可读的格式打印镜像大小和日期 <br> --no-trunc :显示完整的提交记录 <br> -q :仅列出提交记录ID |  |
| 列出本地镜像 | docker images [OPTIONS] [REPOSITORY[:TAG]] | -a :列出本地所有的镜像(含中间映像层) <br> -f :显示满足条件的镜像； | 默认不显示中间映像层 |
| 删除镜像 | docker rmi [OPTIONS] IMAGE [IMAGE...] <br> docker rmi php  | -f :强制删除；<br> --no-prune :不移除该镜像的过程镜像； | 默认移除过程镜像 |
| 从容器创建一个新的镜像 | docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]] | -a :提交的镜像作者 <br> -c :使用Dockerfile指令来创建镜像；<br> -m :提交时的说明文字； <br> -p :在commit时，将容器暂停 |  |
| 创建容器 | docker run --name=ALIAS -p  -d 2222:80 IMAGE_NAME |
| 导入镜像 | docker import [OPTIONS] file- [REPOSITORY[:TAG]] <br> docker import  my_ubuntu_v3.tar runoob/ubuntu:v4   | -c :应用docker 指令创建镜像； <br> -m :提交时的说明文字； |  |
|  |  |  |  |
| 打包容器 | docker export [OPTIONS] CONTAINER <br> docker export -o mysql-`date +%Y%m%d`.tar mysql5 | -o :将输入内容写到文件 |  |
| 检查容器里文件结构的更改 | docker diff [OPTIONS] CONTAINER |  |  |
| 列出容器 | docker ps [OPTIONS] <br> docker ps -a | -a :显示所有的容器，包括未运行的 <br> -f :根据条件过滤显示的内容 <br> -s :显示总的文件大小。 | 状态：created、restarting、up、removing 、paused(暂停)、exited、dead|
| 启动容器 | docker exec -it php /bin/bash |  | 启动并打开命令行 |
| 容器停启用 | docker restart [OPTIONS] CONTAINER | start、stop、restart |  |  |
| 杀掉一个运行中的容器 | docker kill [OPTIONS] CONTAINER <br> docker kill php |  | 强制结束 |
| 删除一个或多个容器 | docker rm [OPTIONS] CONTAINER_LIST | -f :强制 <br> -v :删除与容器关联的卷 |  |
| 在运行的容器中执行命令 | docker exec [OPTIONS] CONTAINER_(NAME or ID) COMMAND [ARG...] <br> docker exec -it CONTAINER /bin/sh <br> docker exec -it nginx nginx -s reload  | -d :分离模式: 在后台运行 <br> -i :即使没有附加也保持STDIN 打开 <br> -t :分配一个伪终端 | |
| 连接到正在运行中的容器 | docker attach [OPTIONS] CONTAINER |  |  |
| 获取容器日志 | docker logs [OPTIONS] CONTAINER <br> docker logs --since="2016-07-01" --tail=10 myNginx | -f : 跟踪日志输出 <br> --since :显示某个开始时间的所有日志 <br> --tail :仅列出最新N条容器日志 <br> -t : 显示时间戳 |  |

## docker-compose

| 命令 | 用途 | 备注 |
| ---- | ---- | ---- |
| docker-compose up | 创建并且启动所有容器 |  |
| docker-compose up -d | 创建并且后台运行方式启动所有容器 |  |
| docker-compose up nginx php mysql | 创建并且启动 指定的多个容器 |  |
| docker-compose up -d nginx php | 创建并且已后台运行的方式启动 指定的多个容器 |  |s
|  |  |  |
| docker-compose start php | 启动服务 |  |
| docker-compose stop php | 停止服务 |  |
| docker-compose restart php | 重启服务 |  |
| docker-compose build php | 构建或者重新构建服务 |  |
|  |  |  |
| docker-compose rm php | 删除并且停止php容器 |  |
| docker-compose down | 停止并删除容器，网络，图像和挂载卷 |  |

## dnmp实践

[github dnmp](https://github.com/yeszao/dnmp)

* cp env.sample .env，修改数据库密码； 修改应用版本前 执行 docker search 确认版本存在
* cp docker-compose.sample.yml docker-compose.yml 选择版本释放注释，注意缩进
* 逐个修改 nginx/conf.d下的conf文件  fastcgi_pass;
```yaml
  php80:

  fastcgi_pass   php80:9000;
```

* mysql5 phpMyAdmin 访问不到数据库

```tips
  自己下载phpMyAdmin,配置nginx
  复制 config.sample.inc.php 文件为 config.inc.php
  修改 $cfg['Servers'][$i]['host'] = 'mysql5'; (对应docker-compose.yml文件的mysql配置)
  访问 phpMyAdmin 报错：配置文件权限错误，不应任何用户都能修改！
  在docker容器下 修改 phpMyAdmin 目录权限为755 

  修改dnmp/services/phpmyadmin/config.user.inc.php文件，修改 PMA_HOST=mysql5 可访问mysql数据库
```
    

## 疑难杂症

### Docker Desktop 启动失败：Docker failed to initialize

* 删除 C:\Users\用户名\AppData\Roaming\Docker 文件夹。
* Docker Desktop 会自动重启