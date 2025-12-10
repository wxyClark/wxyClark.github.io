---
sort: 6
---

# MySQL规范


* MySQL 不区分⼤⼩写，但建议关键字⼤写，表名、列名⼩写
* 每条命令最好⽤英⽂分号结尾
* 每条命令根据需要，可以进⾏缩进或换⾏
* 注释

    + 单⾏注释：#注释⽂字; -- 注释文字(要加空格)
    + 多⾏注释：/*	注释⽂字 */	


## 开发总则

* 禁止在开发环境做测试
* 前后端必须会用一致的字符集(utf8mb4)
* 编写SQL语句 关键词必须全部为大写，每个词必只允许只有一个空格符
* 建议使用预编译语句进行数据库操作
* 关联字段的数量类型、范围 与源数据保持一致

## 命名规范
[分享一份大佬的MySQL数据库设计规范，值得收藏](https://zhuanlan.zhihu.com/p/165940906)

```danger
命名使用小写字母、下划线、数字，字母开头，表意明确
```

* 【创建数据库】必须显式指定字符集，并且字符集只能是utf8或者utf8mb4
* 【库的名称】32个字符以内，业务系统名称_子系统名，分库名称：库通配名_编号/时间
* 【表的名称】32个字符以内，显式指定字符集为utf8或utf8mb4。必须有comment
* 【中间表】用于保留中间结果集，名称必须以tmp_开头，以日期结束
* 【备份表】用于备份或抓取源表快照，名称必须以bak_开头。中间表和备份表定期清理
* 相关模块的表名(前缀标识)与表名之间【尽量体现join关系】,如user表和user_login表
* 【列的名称】32个字符以内，必须有comment，枚举值在comment中罗列
* 【索引名称】主键的名称以“pk_”开头，唯一键以“uk_”或“uq_”开头，普通索引以“idx_”开头，一律使用小写格式，以表名/字段的名称或缩写作为后缀

## 数据表设计规范

```danger
必须显式指定表存储引擎类型，如无特殊需求，一律为InnoDB
尽量避免null值
```

* 【*】所有存储相同数据的列名和列类型必须一致，
* 【*】禁止使用预留字段，禁止存储图片、文件等二进制数据
* 【*】数据库环境隔离，开发、测试环境不能使用生产库
* 【*】一个表最多20个字段，数据冷热分离，减少列的宽度

* 核心表必须设置字段：create_at、updated_at、updated_by,便于查问题
* (建表预估)数据量大的表做分表设计，id自增bigInt，业务_id使用分布式ID(bigInt)
* 表中所有字段尽可能都是NOT NULL属性
```
MySQL8之前版本Text、blob、json设为NUll，垂直拆分到其他表里
NULL值会存在每一行都会占用额外空间、数据迁移容易出错、聚合计算结果偏差
```

* 【反范式设计】把经常需要join查询的字段，在其他表里冗余一份，减少join查询

## 字段设计规范

```danger
优先选择符合存储需要的最小数据类型，优先使用整数类型
```

* 自增列推荐使用bigint类型无符号数
* IP地址字段推荐使用int类型(4字节)，不推荐用char(15)（至少15字节）
* 存储金钱的字段，建议用int(除以100得到两位小数)，double占用8字节，空间浪费
* 区分度小的status、type等字段推荐使用tinytint或者smallint类型节省存储空间。
* 时间类型尽量选取timestamp（4字节），datetime（8字节），禁止使用字符串存储日期时间
* 文本数据尽量用varchar(2+n)存储(20 < n > 2700)。因为varchar是变长存储，比char更省空间,但是会产生碎片。

```tip
Innodb中当一行记录超过8098字节[[8098/3=2699.3]]时，会将该记录中选取最长的一个字段将其768字节放在原始page里，该字段余下内容放在overflow-page里。
不幸的是在compact行格式下，原始page和overflow-page都会加载

varchar最多存65535字节(在utf8字符集下最多存21844个字符,超过会自动转换为mediumtext字段[最多存2^24/3个字符],longtext最多存2^32/3个字符。一般建议用varchar类型，字符数不要超过2700[8098/3=2699.3]。),
```

* 不推荐使用enum，set，浪费空间，更新不方便。推荐使用tinyint或smallint。
* 不推荐使用blob，text等类型。它们都比较浪费硬盘和内存空间。
* 两张表中需要建⽴逻辑外键关系的字段类型需要⼀致
* 要设置外键的字段不能为主键

## SQL使用规范

```danger
禁止使用相同的账号跨库操作(各执其职，互不越权)
禁止在WHERE语句中进行计算(索引失效)
```
```danger
生产环境禁止使用hint，如sql_no_cache，force index，ignore key，straight join等。
因为hint是用来强制SQL按照某个执行计划来执行，但随着数据量变化我们无法保证自己当初的预判是正确的，因此我们要相信MySQL优化器！
```

```danger
【高危语句】
* 禁用update|delete t1 … where a=XX limit XX; 这种带limit的更新语句会导致主从不一致，导致数据错乱。建议加上order by PK。
* 禁止使用关联子查询，如update t1 set … where name in(select name from user);效率极其低下
* 禁用procedure、function、trigger、views、event、外键约束。消耗数据库资源，降低数据库实例可扩展性。推荐都在程序端实现。
* 禁用insert into …on duplicate key update…在高并发环境下，会造成主从不一致。
* 禁止联表更新语句，如update t1,t2 where t1.id=t2.id…。
* 禁止使用ORDER BY RAND()随机排序语句(符合查询条件的全量数据都会生成随机值)
* 危险的SQL语句(update、delete)必须带上索引作为条件(WHERE)，量大需要分组操作，避免锁表
```

### 【INSERT】
* 大批量写操作尽可能合理地分批次处理(500一组，防止死锁)
* 禁止使用带有数据值却不带有字段键名的INSERT操作,显式声明字段

```sql
INSERT INTO user (`username`,`age`) VALUES ('alicfeng',23);

INSERT INTO NEW_TABLE_NAME 
SELECT * FROM OLD_TABLE_ANME
WHERE CONDITION ;
```

### 【UPDATE】
* 禁止一条语句同时对多个表进行写操作
* 除静态表或小表（100行以内），DML语句必须有where条件，且使用索引查找。

### 【JOIN】
* 在多表join中，尽量选取结果集较小的表作为驱动表，来join其他表。
* 禁止在业务的更新类SQL语句中使用join，比如update t1 join t2…。
* 多表连接查询推荐使用别名
* 合理拆分大SQL为多个小SQL（一个SQL只能用到一个cpu核心，多路并行）
* 尽可能避免使用JOIN关联过多的表（尽量不超过3个表，最多不超过5个），MySQL上限61个表
* 尽可能使用JOIN替代子查询操作(子查询的结果集会被存储到临时表中无法使用索引)

### 【SEARCH】
* 写入和事务发往主库，只读SQL发往从库，读写分离
* 合并操作、减少与数据库的交互次数(见到foreach里的sql就要考虑能否向上提取)
* 尽可能使用IN代替OR语句
* 尽可能使用EXIST|NOT EXIST替代IN | NOT IN
* IN语句参数的个数尽量控制在500以内(减少底层扫描，减轻数据库压力从而加速查询)
* 尽可能避免使用LIKE添加%前缀进行模糊查询(左模糊会导致前缀索引失效)
* 使用UNION ALL而不是使用UNION(重复值扫描),在已知数据没有重复或无须删除重复行的前提下
* 严禁使用SELECT *查询字段(可能导致覆盖索引失效,浪费CPU、I/O、带宽)
* 查询语句务必带上索引以提高查询效率(如user_id)
* 必须避免数据类型隐式转换(验证int类型条件加引号)
* 注意LIMIT分页查询效率，LIMIT越大效率越低，S2比S1效率高

```sql
S1   SELECT `username` FROM `user` LIMIT 10000,20;   
S2   SELECT `username` FROM `user` WHERE id>10000 LIMIT 20;
```

### 分组、排序

* 减少使用order by，和业务沟通能不排序就不排序，或将排序放到程序端去做。
* 【order by、group by、distinct】这些语句较为耗费CPU，尽量利用索引直接检索出排序好的数据,where条件过滤出来的结果集请保持在1000行以内，否则SQL会很慢。

```sql
如where a=1 order by b可以利用key(a,b)
```

## 事务

```danger
涉及事务的所有表必须是InnoDB
```

* 批量处理的数据单次执行行数上限为500,array_chunk
* 线上建议事务隔离级别为repeatable-read。
* 事务里包含SQL尽可能少。过长的事务会导致锁数据较久，MySQL缓存、连接消耗过多等雪崩问题。
* 尽量把一些典型外部调用移出事务，如调用webservice，访问文件存储等，从而避免事务过长。
* 更新语句尽量基于主键或unique key，否则会产生间隙锁(内部扩大锁范围)，性能下降，产生死锁。
* 对于MySQL主从延迟严格敏感的select语句，请开启事务强制访问主库。

## Null导致的神坑

```danger
NULL 导致的坑让⼈防不胜防，强烈建议创建字段的时候字段不允许为NULL，给个默认值
```

* **判断是否为空只能⽤ IS NULL、IS NOT NULL**
* NULL作为布尔值的时候，不为1也不为0
* 任何值和NULL使⽤运算符（>、<、>=、<=、!=、<>）或者（in、notin、any、some、all），返回值都为NULL
* 当IN和NULL⽐较时，⽆法查询出为NULL的记录
* **当NOTIN后⾯有NULL值时，不论什么情况下，整个sql的查询结果都为空**
* count(字段) ⽆法统计字段为NULL的值，count(*)可以统计值为null的⾏
* 当字段为主键的时候，字段会⾃动设置为 not null
