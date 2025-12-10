---
sort: 7
---

# 实战经验

## 优化思路

性能参数：qps(每秒处理的请求数量)、 fps(每秒处理的事务数量)

### 配置优化

### 库优化

### 表优化

### 字段优化

### 查询优化

* 调整Where字句中的连接顺序

```sql
MySQL 采用从左往右的顺序解析 where 子句，可以将过滤数据多的条件放在前面，最快速度缩小结果集。

使⽤ between and 的时候，区间跨度不要太⼤


```

* 索引优化
  
    + 在区分度⾼的字段上⾯建⽴索引，区分度低的字段不建索引
    + 索引覆盖可以减少回表操作
    + 禁⽌对索引字段使⽤函数、运算符操作，会使索引失效
    + 排序字段尽量使用索引字段，可以考虑放在组合索引的后边，如:(userid,addtime)
    + 联合索引注意最左匹配原则：必须按照从左到右的顺序匹配，

      + mysql会⼀直向右匹配**直到遇到范围查询**(>、<、between、like)就停⽌匹配，
      + ⽐如a = 1 and b = 2 and c > 3 and d = 4 
      + 如果建⽴(a,b,c,d)顺序的索引，d是⽤不到索引的，
      + 如果建⽴(a,b,d,c)的索引则都可以⽤到，a,b,d的顺序可以任意调整

### 代码优化

```danger
foreach + SQL 操作
优先考虑批量操作
```

## 锁

### 隔离级别

### 怎样实现死锁
#### 原理

### 怎样解决死锁
#### 查看死锁

### 怎样避免死锁

## 查询优化

### 发现问题：慢查询日志

* 开启慢查询日志配置
  
```conf
[mysqld]
log_output='FILE,TABLE';

# 代表开启慢sql参数进行开启
slow_query_log=ON 

# 查询时间（秒）
long_query_time=0.001
```

* 重启服务生效
  
```cs
service mysqld restart
```

* 修改全局服务配置——不需要重启就可以生效

```cs
set global log_output='TABLE,FILE';
set global slow_query_log = 'NO';
set long_query_time = 0.001;
```

#### 配置参数

当log_output设置为TABLE的时候，就会将mysql的慢查询日志记录到mysql.slow_log表中去

### 分页查询

```tip
分页读取数据 后修改数据 要考虑 使用 page++ 还是 page==1

如果修改的数据导致查询结果集变化，则应使用page==1 避免跳过了一半数据 
```

当 offset 偏移量大的时候，sql执行回很慢

* 1、使用 id > $page * $page_size offset 0 limit $page_size
* 2、使用标识位标识 已执行过的数据，通过 do{} while (count($rs) == $page_size)
* 3、分页数据状态修改后，**谨慎考虑**查询的页码是否要+1
