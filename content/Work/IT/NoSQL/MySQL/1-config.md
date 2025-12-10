---
sort: 1
---
# 配置

主库配置

```conf
[mysqld]
log-bin = /data/3306/mysql-bin
# 主从配置的每个实例的 server-id 不能冲突 推荐使用服务器IP地址最后一段(但不适合多实例交叉配置)
server-id = 1 

# binlog功能已开启
log_bin   | ON 

```

从库配置

```conf
MASTER_HOST='10.0.0.7',         
MASTER_PORT=3306,

# 主库上建立的用于复制的用户rep
MASTER_USER='rep',               
MASTER_PASSWORD='rep用户的密码', 
# show master status时查看到的二进制日志文件名称，注意不能多空格
MASTER_LOG_FILE='mysql-bin.000008',  
# show master status时查看到的二进制日志偏移量，【注意不能多空格】,字符串用单引号括起来，数值不用引号
MASTER_LOG_POS=342,  

# 必须要有这个参数
log-slave-updates      
log-bin = /data/3307/mysql-bin
# 日期过期时间  相当于find /data/3307/ -type f -name " mysql-bin.000*" -mtime +7 |xargs rm -f
expire_logs_days = 7  
```

## 权限配置

* 程序使用的数据库账号不能使用super
* 对于程序连接数据库账号，遵循权限最小原则，不越权，不跨库
* 权限生效：flush privileges;之后 用户重新登录
* 权限验证: 

  +  连接权限——用户名@来源(ip或主机名)；
        
```sql
create user ⽤户名[@主机名] [identified by '密码'];
例：create user 'test2'@'localhost' identified by '123';
例：create user 'test4'@'192.168.11.%' identified by '123';
SET PASSWORD FOR '⽤户名'@'主机' = PASSWORD('密码');

update user set password|authentication_string = password('321') where user = 'test1' and host = '%';
flush privileges;
```

  + 操作权限——create(table、index)、select、delete、update、alter

```sql
grant privileges ON database.table TO 'username'[@'host'] [with grant option]

--  给test1授权可以操作所有库所有权限，相当于dba
例：grant all on *.* to 'test1'@‘%’;

--  test1可以对seata库中所有的表执⾏select、update
例：grant select,update on seata.* to 'test1'@'%';

--  test1⽤户只能查询mysql.user表的user,host字段
例：grant select(user,host) on mysql.user to 'test1'@'localhost';
```

查看用户权限配置
```sql
--  查看当前用户的权限
show grants;

--  查看指定用户的权限
show grants for '⽤户名'[@'主机']
例：show grants for 'test1'@'localhost';

--  撤销用户权限
revoke privileges ON database.table FROM '⽤户名'[@'主机'];
例：revoke select(host) on mysql.user from test1@localhost;

--  删除用户
drop user '⽤户名'[@‘主机’]
例： drop user test1@localhost;

delete from user where user='⽤户名' and host='主机';
flush privileges;
```

## 参数配置

* 启用慢查询日志
```conf
# 设置日志文件
set global slow_query_log_file = /PATH/slow_mysql.log  
# 记录未使用索引的sql查询
set global log_queries_not_using_indexes = on  
# 慢查询判定标准，1秒以上
set global long_query_time = 1   
```
* 分析慢查询日志

```cs
mysqldumpslow slow-mysql.log
```

## 安全

* MySQL管理员的账号root密码默认为空，极不安全

```cs
mysqladmin -u root -S /data/3306/mysql.sock password '至少8位' 
```

* 禁止使用pkill、kill-9、killall-9等命令强制杀死数据库，这会引起数据库无法启动等故障的发生。
  
[企业血的教训案例](http://oldboy.blog.51cto.com/2561410/1431161)

## 备份&恢复

```sql
mysqldump [OPTIONS] database [tables]

-- 注意：-A 表示备份所有库；-B表示增加 use DB 和 drop等（导库时会直接覆盖原有的）
-- 如果备份时使用了-A参数，则在还原数据到从库实例时，登录从库的密码也被登录主库的密码覆盖
mysqldump -uroot -p'密码' -S /data/3306/mysql.sock --events -A -B |gzip >/server/backup/mysql_bak.$（date +%F）.sql.gz
```


* MySQL的主从复制是其自带的功能，无需借助第三方工具

    MySQL的主从复制并不是数据库磁盘上的文件直接拷贝，Master端的binlog记录功能(Slave可以不开，节省性能)
      从库需要记录binlog的应用场景：当前的从库还要作为其他从库的主库，例如级联复制或双主互为主从场景的情况下。
    而是通过逻辑的binlog日志复制(Master——>Slave)到要同步的服务器本地，
    然后由本地的线程读取日志里面的SQL语句，重新应用到MySQL数据库中。

* 从服务器作为主服务器的实时数据备份
* 主从服务器实现读写分离，从服务器实现负载均衡

    有为外部用户提供查询服务的从服务器，
    有内部DBA用来数据备份的从服务器，
    还有为公司内部人员提供访问的后台、脚本、日志分析及供开发人员查询使用的从服务器。
    这样的拆分除了减轻主服务器的压力外，还可以使数据库对外部用户浏览、内部用户业务处理及DBA人员的备份等互不影响

* 通过程序实现读写分离（性能和效率最佳，推荐）——select语句连接读库句柄，update、insert、delete时，连接写库句柄

* MySQL主从复制原理过程详细描述
  
前置条件：主库开启binlog日志，主库上创建一个可以连接主库的账号，权限是允许主库的从库连接并同步数据。

```
1）在Slave服务器上执行start slave命令开启主从复制开关，开始进行主从复制(实现对主数据库锁表只读  flush table with read lock, 表锁超时会失效)。 
2）Slave服务器的I/O线程会通过在Master上已经授权的复制用户权限请求连接Master服务器，并请求从指定binlog日志文件的指定位置（偏移量）之后开始发送binlog日志内容。
3）Master服务器接收到来自Slave服务器的I/O线程的请求后，其上负责复制的I/O线程会根据Slave服务器的I/O线程请求的信息分批读取指定binlog日志文件指定位置之后的binlog日志信息，然后返回给Slave端的I/O线程。返回的信息中除了binlog日志内容外，还有在Master服务器端记录的新的binlog文件名称，以及在新的binlog中的下一个指定更新位置。 
4）当Slave服务器的I/O线程获取到Master服务器上I/O线程发送的日志内容、日志文件及位置点后，会将binlog日志内容依次写到Slave端自身的Relay Log（即中继日志）文件（MySQL-relay-bin.xxxxxx）的最末端，并将新的binlog文件名和位置记录到master-info文件中，以便下一次读取Master端新binlog日志时能够告诉Master服务器从新binlog日志的指定文件及位置开始请求新的binlog日志内容。
5）Slave服务器端的SQL线程会实时检测本地Relay Log中I/O线程新增加的日志内容，然后及时地把Relay Log文件中的内容解析成SQL语句，并在自身Slave服务器上按解析SQL语句的位置顺序执行应用这些SQL语句，并在relay-log.info中记录当前应用中继日志的文件名及位置点。

锁表后，一定要单开一个新的SSH窗口，导出数据库的所有数据，如果数据量很大（50GB以上），并且允许停机，可以停库直接打包数据文件进行迁移，那样更快

unlock tables
```

```tip
当企业面试MySQL主从复制原理时，不管是面试还是笔试，都要尽量【画图表达】，而不是口头讲或文字描述

主从复制是异步的逻辑的SQL语句级的复制
复制时，主库有一个I/O线程，从库有两个线程，即I/O和SQL线程
实现主从复制的必要条件是主库要开启记录binlog功能
作为复制的所有MySQL节点的server-id都不能相同
binlog文件只记录对数据库有更改的SQL语句（来自主数据库内容的变更），不记录任何查询（如select、show）语句
```

### 小技巧

set global sql_slave_skip_counter=n；#n取值>0，忽略执行N个更新。

slave-skip-errors = 1032，1062，1007 根据可以忽略的错误号事先在配置文件中配置，跳过指定的不影响业务数据的错误 

binlog记录模式，例如：row level模式就比默认的语句模式要好

## 多实例

公司资金紧张，但是数据库又需要各自尽量独立地提供服务时，可交叉配置多实例：
```tip
可以通过3台服务器部署9～15个实例(一般是从库多实例),生产环境中，一般一台机为3～4个实例为佳。
交叉做主从复制、数据备份及读写分离，
这样就可达到9～15台服务器每个只装一个数据库才有的效果
```

* 开启多个不同的服务器端口，同时运行多个MySQL服务进程，这些服务进程通过不同的socket监听不同的服务器端口来提供服务。

    不同实例的sock虽然名字相同，但是路径是不同的，因此是不同的文件。 
    mysql -S /data/3306/mysql.sock
    mysql -S /data/3307/mysql.sock

* A 机器 3306(写服务) + B 机器3307(读服务)
* B 机器 3306(写服务) + A 机器3307(读服务)
* 授权MySQL多实例所有启动文件的mysql可执行，设置700权限最佳，注意不要用755权限(启动文件里有数据库管理员密码，会被读取到)
* 弊端：当某个数据库实例并发很高或有SQL慢查询时，整个实例会消耗大量的系统CPU、磁盘I/O等资源，导致其他服务质量一起下降

```danger
务必把MySQL命令路径放在PATH路径中其他路径的前面，
否则，可能会导致使用的mysql命令和编译安装的mysql命令不是同一个，进而产生错误。
```

```bash
# mkdir-p/data/3306/data；mkdir-p/data/3307/data两条命令
mkdir-p/data/{3306,3307}/data

# 授权MySQL多实例所有启动文件的mysql可执行权限 700
find /data -name mysql|xargs chmod 700

# 注意！echo后是单引号呦
echo 'export PATH=/application/mysql/bin：$PATH' >>/etc/profile

source  /etc/profile

# 把mysql命令所在路径链接到全局路径/usr/local/sbin/的下面
ln -s /application/mysql/bin/* /usr/local/sbin/
```

## 参数查询

| 参数  | 命令  |   |
| ---- | ---- |---- |
| 查看系统所有变量 | show [global | session] variables; |---- |
| 查看全局变量 | show global variables; |---- |
| 查看会话变量 | show session variables; <br> show variables; |---- |
| ---- | ---- |---- |
| ---- | ---- |---- |
| 默认情况下自动解锁的时长 | show variables like '%timeout%' |  |
| 查看隔离级别 | show variables like 'transaction_isolation' | 默认 READ-COMMITTED |
| 查看主库状态 | show master status | 命令显示的信息要记录在案，后面的从库导入全备后，继续和主库复制时就是要从这个位置开始。 |
| 当前版本 | select version() |  |
| 当前数据库 | select database() |  |
| 当前表结构 | desc TABLE_NAME |  |
| 当前表建表语句 | show create table TABLE_NAME |  |
| 当前表的状态 | SHOW TABLE STATUS LIKE 'user' \G | Rows 表中的行数。<br>对于MyISAM和其他一些存储引擎，该值是精确的，<br>但对于InnoDB，该值是估计值。 |

## 参数设置

| 参数  | 命令  |   |
| ---- | ---- |---- |
| 给了级别 | SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; | 在当前会话设置隔离级别  |

## SQLMODE

ONLY_FULL_GROUP_BY