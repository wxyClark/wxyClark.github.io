# Nginx日志

crontab -e 设置日志按天切割

```bash
# 此处意思是每天凌晨0点执行后面的/server/scripts/cut_nginx_log.sh脚本，>/dev/null 2>&1表示任何输出都不要。
00 00 * * * /bin/sh /server/scripts/cut_nginx_log.sh >/dev/null 2>&1 
```