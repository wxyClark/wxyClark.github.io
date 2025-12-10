---
sort: 9
---

# 事务&锁

[CSDN mysql数据库锁与隔离级别](https://blog.csdn.net/baidu_14922873/article/details/84777498)
[博客园 MySQL锁机制与隔离级别](https://www.cnblogs.com/aaron-agu/p/13461147.html)

* MySQL默认采用自动提交（AUTOCOMMIT）模式。也就是说，如果不是显式地开始一个事务，则每个查询都被当作一个事务执行提交操作
* 加锁也需要消耗资源
* 服务器会为诸如ALTER TABLE之类的语句使用表锁，而忽略存储引擎的锁机制。
* 即使存储引擎不支持事务，也可以通过LOCK TABLES语句为应用提供一定程度的保护，这些选择用户都可以自主决定。
* 写锁则是排他的，也就是说一个写锁会阻塞其他的写锁和读锁；
* READ LOCAL表锁支持某些类型的并发写操作。另外，写锁也比读锁有更高的优先级，因此一个写锁请求可能会被插入到读锁队列的前面
* 行级锁可以最大程度地支持并发处理（同时也带来了最大的锁开销）。众所周知，在InnoDB和XtraDB，以及其他一些存储引擎中实现了行级锁。

| 表引擎   | 表锁  | 页锁  | 行锁  |
| ---- | ---- |---- |---- |
| InnoDB | √ | × | √ |
| MyISAM | × | × | × |

* 事务内的语句，要么全部执行成功，要么全部执行失败。


## 隔离级别

```sql
-- 查mysql隔离级别
show variables like 'tx_isolation'
SELECT @@tx_isolation;
```

```danger
MySQL服务器层不管理事务，事务是由下层的存储引擎实现的。所以在同一个事务中，使用多种存储引擎是不可靠的(非事务型的表上的变更就无法撤销)。

MySQL可以通过执行SET TRANSACTION ISOLATION LEVEL命令来设置隔离级别

新的隔离级别会在下一个事务开始的时候生效

InnoDB引擎也支持所有的隔离级别。
```

| name | 事务隔离级别 | 脏读 | 不可重复读  | 幻读 | 读取一致性 | 备注 |
| ---- | ---- | ---- |---- | ---- | ---- | ---- |
| read-uncommitted | 读未提交 | 是 | 是 | 是 | 物理级(最低) | 通常不使用 |
| read-committed | 读已提交(不可重复读) | 否 | 是 | 是 | 语句级 | 大多数数据库系统的默认隔离级别<br> 提交前数据不可见 |
| repeatable-read **默认** | 可重复读 | 否 | 否 | 是 | 事务级 | MySQL的默认隔离级别 <br> 需要解决**幻读** 可用MVCC |
| senalizable | 串行化 | 否 | 否 | 否 | 事务级(最高) | 最高的隔离级别 避免了幻读问题 <br> 会在读取的每一行数据上都加锁，所以可能导致大量的超时和锁争用的问题 <br> 适用于 银行系统、分布式系统 |

```tip
可以认为MVCC是行级锁的一个变种，但是它在很多情况下避免了加锁操作，因此开销更低。

虽然实现机制有所不同，但大都实现了非阻塞的读操作，写操作也只锁定必要的行。

MVCC的实现，是通过保存数据在某个时间点的快照来实现的

InnoDB的MVCC，是通过在每行记录后面保存两个隐藏的列来实现的。这两个列，一个保存了行的创建时间，一个保存行的过期时间（或删除时间)

MVCC只在REPEATABLE READ和READ COMMITTED两个隔离级别下工作。
```

**可重复读**：个事务操作中对于⼀个读取操作不管多少次，读取到的结果都是⼀样的。

**幻读**：在可重复读的模式下才会出现，示例：

    事务A操作如下：
        
        1、打开事务
        2、查询号码为X的记录，不存在
        3、插⼊号码为X的数据，插⼊报错（为什么会报错，先向下看）
        4、查询号码为X的记录，发现还是不存在（由于是可重复读，所以读取记录X还是不存在的）

    事物B操作：
        在事务A第2步操作时插⼊了⼀条X的记录，
        所以会导致A中第3步插⼊报错（违反了唯⼀约束）

    上⾯操作对A来说就像发⽣了幻觉⼀样，明明查询X（A中第⼆步、第四步）不存在，但却⽆法插⼊成功

## 事务

```tip
InnoDB采用的是两阶段锁定协议（two-phase locking protocol）。

在事务执行过程中，随时都可以执行锁定，锁只有在执行COMMIT或者ROLLBACK的时候才会释放，并且所有的锁是在同一时刻被释放。

前面描述的锁定都是隐式锁定，InnoDB会根据隔离级别在需要的时候自动加锁。
```

事务的4个基本特征ACID

| name    | 特性  | 注释  | 怎样实现 |
| ---- | ---- |---- |---- |
| Atomic | 原子性 | 整体操作要么全部成功,要么全部失败。 | undo log |
| Consistency | 一致性 | 仅仅有合法的数据能够被写入数据库，否则事务应该将其回滚到最初状态。 | 业务代码逻辑 |
| Isolation | 隔离性 | 并行事务的改动必须与其它并行事务的改动相互独立。 | MVCC |
| Durability | 持久性 | 事务结束后，事务处理的结果必须可以得到固化。| 内存+redo log |

* 事务提交的时候通过 redo log 刷盘，宕机的时候可以从 **redo log** 恢复
* **undo log** 日志保证，它记录了需要回滚的日志信息，事务回滚时撤销已经执行成功的 sql
* mysql 中事务默认是隐式事务，执⾏ **insert、update、delete** 操作的时候，数据库⾃动开启事务、提交或回滚事务。
* 是否开启隐式事务是由变量 **autocommit** 控制的
  
在事务中我们执⾏了⼀⼤批操作，可能我们只想回滚部分数据,可以使⽤ **savepoint** 来实现
```sql
start transaction;
    insert into test1 values (1);

    -- 设置⼀个保存点
    savepoint part1; 

    insert into test1 values (2);
    
    --  将savepoint = part1的语句到当前语句之间所有的操作回滚
    rollback to part1; 

    --  提交事务
    commit;
```

只读事务: 
```sql
start transaction read only;
    select * from test1;

    --  Cannot execute statement in a READ ONLY transaction.
    --  只读事务中执⾏delete会报错
    delete from test1;

    commit;
```

### 显式锁定

```tip
除了事务中禁用了AUTOCOMMIT，可以使用LOCK TABLES之外，其他任何时候都不要显式地执行LOCK TABLES，不管使用的是什么存储引擎。
```

* InnoDB也支持通过特定的语句进行显式锁定，这些语句不属于SQL规范。这是在服务器层实现的，和存储引擎无关。
```sql
SELECT ... LOCK IN SHARE MODE 
SELECT ... FOR UPDATE 
MySQL也支持LOCK TABLES和UNLOCK TABLES语句，
```

* 它们有自己的用途，但并不能替代事务处理。
* 如果应用需要用到事务，还是应该选择事务型存储引擎。
## 锁


* 共享锁(S)：又称读锁。允许一个事务去读一行，阻止其他事务获得相同数据集的排他锁。
```
若事务T对数据对象A加上S锁，则事务T可以读A但不能修改A，其他事务只能再对A加S锁，而不能加X锁，直到T释放A上的S锁。
这保证了其他事务可以读A，但在T释放A上的S锁之前不能对A做任何修改。
```
* 排他锁(X)：又称写锁。允许获取排他锁的事务更新数据，阻止其他事务取得相同的数据集共享读锁和排他写锁。
```
若事务T对数据对象A加上X锁，事务T可以读A也可以修改A，其他事务不能再对A加任何锁，直到T释放A上的锁。
```
* 意向共享锁(IS)：事务打算给数据行共享锁，事务在给一个数据行加共享锁前必须先取得该表的IS锁。
* 意向排他锁(IX)：事务打算给数据行加排他锁，事务在给一个数据行加排他锁前必须先取得该表的IX锁。

| 兼容性列表 | X | IX | S | IS |
| ---- | ---- |---- |
| X | 冲突 | 冲突 | 冲突 | 冲突 |
| IX | 冲突 | 兼容 | 冲突 | 兼容 |
| S | 冲突 | 冲突 | 兼容 | 兼容 |
| IS | 冲突 | 兼容 | 兼容 | 兼容 |

### MyISAM表锁：表共享读锁（Table Read Lock）和表独占写锁（Table Write Lock）

* 加锁：lock tables tablename1 read, tablename2 read;
* 解锁：Unlock tables;
* 执行更新操作 （ UPDATE、DELETE、INSERT 等）前，会自动给涉及的表加写锁，这个过程并不需要用户干预，因此，用户一般不需要直接用LOCK TABLE命令给MyISAM表显式加锁。


### InnoDB行锁

* 乐观锁：假设认为数据一般情况下不会造成冲突，提交更新时，才会校验版本号是否有冲突。
* 悲观锁：默认认为对数据的访问一定会产生并发问题，为了提高并发效率，会将悲观锁细化为读锁与写锁
```
读锁，又称共享锁，多个连接在同一时间读取同一个资源，二者不相互干扰。
写锁，又叫排它锁，一个写锁会阻塞其他的写锁和读锁。
```

* 悲观锁是数据库自身机制来实现的

| 锁级别 | 开销 | 加锁速度 | 是否会出现死锁 | 锁定粒度 | 发生锁冲突概率 | 并发度 | 适合场景 |
| ---- | ---- |---- |---- |---- | ---- |---- |---- |
| 表级锁 | 开销小 | 加锁快 | **不会** | 大 | 最高 | 最低 | 查询 |
| 页面锁 | 表锁< 中 <行锁 | 表锁< 中 <行锁 | 会 | 行锁< 中 <表锁 | 表锁< 中 <行锁 | 一般 |  |
| 行级锁 | 开销大 | 加锁慢 | 会 | 小 | **最低** | **最高** | 在线事务处理(OLTP) |

* InnoDB 存储引擎的锁的算法有三种


| lock    | 名称  | 作用范围 |
| ---- | ---- |---- |
| Record lock | 记录锁 | 单个行记录上的锁 |
| Gap lock | 间隙锁 | 锁定一个范围，不包括记录本身 |
| Next-key lock : record+gap | 临键锁 | 锁定一个范围，包含记录本身 |

```danger
MySQL InnoDB 的 REPEATABLE-READ（可重读）并不保证避免幻读，需要应用使用加锁读来保证。
而这个加锁度使用到的机制就是 Next-Key Locks。
```


```danger
MySQL InnoDB 的 delete 使用 业务条件 删除数据 即使是 uniq_key 也会造成间隙锁 导致并行死锁问题
事务中的删除操作 尽可能 先查询数据记录的id，再通过id删除数据
```


### 如何加锁

```danger
【MySQL的行锁是针对索引加的锁】，不是针对记录加的锁，所以虽然是访问不同行的记录，但是如果是使用相同的索引键，是会出现锁冲突的。
```

* 意向锁是InnoDB自动加的，不需用户干预。
* update,delete,insert都会自动
* select 语句默认不会加任何锁类型
* select …for update 语句加排他锁
* select … lock in share mode 加共享锁
  
```
主要用在需要数据依存关系时来确认某行记录是否存在，并确保没有人对这个记录进行UPDATE或者DELETE操作。

但是如果当前事务也需要对该记录进行更新操作，则很有可能造成死锁，

对于锁定行记录后需要进行更新操作的应用，应该使用SELECT… FOR UPDATE方式获得排他锁。
```

* 只有通过索引条件检索数据，InnoDB才使用行级锁，否则将使用表锁，这个需要通过explain来确定查询是否走索引！
* 当表有多个索引的时候，不同的事务可以使用不同的索引锁定不同的行，另外，不论是使用主键索引、唯一索引或普通索引，InnoDB都会使用行锁来对数据加锁。

### 分布式锁

* 分布式锁使⽤者位于不同的机器中，锁获取成功之后，才可以对共享资源进⾏操作
* 锁具有重⼊的功能：即⼀个使⽤者可以多次获取某个锁
* 获取锁有超时的功能：即在指定的时间内去尝试获取锁，超过了超时时间，如果还未获取成功，则返回获取失败
* 能够⾃动容错：持有锁的时候可以加个持有超时时间，超时间强制释放

## 死锁

```tip
死锁是指两个或者多个事务在同一资源上相互占用，并请求锁定对方占用的资源，从而导致恶性循环的现象。

当多个事务试图以不同的顺序锁定资源时，就可能会产生死锁。

多个事务同时锁定同一个资源时，也会产生死锁。

InnoDB目前处理死锁的方法是，将持有最少行级排他锁的事务进行回滚（这是相对比较简单的死锁回滚算法）。
```

通常来说，死锁都是应用设计的问题，通过调整业务流程、数据库对象设计、事务大小、以及访问数据库的SQL语句，绝大部分都可以避免。下面就通过实例来介绍几种死锁的常用方法。

* 1.在应用中，如果不同的程序会并发存取多个表，应尽量约定以相同的顺序为访问表，这样可以大大降低产生死锁的机会。如果两个session访问两个表的顺序不同，发生死锁的机会就非常高！但如果以相同的顺序来访问，死锁就可能避免。
* 2.程序以批量方式处理数据的时候，如果事先对数据排序，保证每个线程按固定的顺序来处理记录，也可以大大降低死锁的可能。
* 3.在事务中，如果要更新记录，应该直接申请足够级别的锁，即排他锁，而不应该先申请共享锁，更新时再申请排他锁，甚至死锁。
* 4.在REPEATEABLE-READ隔离级别下，如果两个线程同时对相同条件记录用SELECT…ROR UPDATE加排他锁，在没有符合该记录情况下，两个线程都会加锁成功。程序发现记录尚不存在，就试图插入一条新记录，如果两个线程都这么做，就会出现死锁。这种情况下，将隔离级别改成READ COMMITTED，就可以避免问题。
* 5.当隔离级别为READ COMMITED时，如果两个线程都先执行SELECT…FOR UPDATE，判断是否存在符合条件的记录，如果没有，就插入记录。此时，只有一个线程能插入成功，另一个线程会出现锁等待，当第１个线程提交后，第２个线程会因主键重出错，但虽然这个线程出错了，却会获得一个排他锁！这时如果有第３个线程又来申请排他锁，也会出现死锁。对于这种情况，可以直接做插入操作，然后再捕获主键重异常，或者在遇到主键重错误时，总是执行ROLLBACK释放获得的排他锁。

如果出现死锁，可以用SHOW INNODB STATUS命令来确定最后一个死锁产生的原因和改进措施。

## 依赖关系

```danger
如果一个数据的更细依赖的另一条数据必须先更新

则在读已提交隔离级别下，应该拆分成两个事务，顺序执行
```

## 存储过程 procedure

```tip
存储过程不能修改，若涉及到修改的，可以先删除，然后重建。

存储过程中是否需要开启事务？
```

```sql
--  【创建存储过程】
--  参数模式有3种：
--      in：该参数可以作为输⼊，也就是该参数需要调⽤⽅传⼊值。
--      out：该参数可以作为输出，也就是说该参数可以作为返回值。
--      inout：该参数既可以作为输⼊也可以作为输出，也就是说该参数需要在调⽤的时候传⼊值，又可以作为返回值。
--      参数模式默认为IN。
--  ⼀个存储过程可以有多个输⼊、多个输出、多个输⼊输出参数
CREATE PROCEDURE 存储过程名([参数模式] 参数名 参数类型)
BEGIN
    存储过程体
END

--  【调⽤存储过程】
CALL 存储过程名称(参数列表);

--  【删除存储过程】
DROP PROCEDURE [if exists] 存储过程名称;

--  【查看存储过程】
SHOW CREATE PROCEDURE 存储过程名称;
```

实例：
```sql
--  【创建存储过程】
/*设置结束符为$*/
DELIMITER $
/*如果存储过程存在则删除*/
DROP PROCEDURE IF EXISTS proc2;
/*创建存储过程proc2*/
CREATE PROCEDURE proc2(id int,age int,in name varchar(16),out user_count int,out max_id int)
BEGIN
    INSERT INTO t_user VALUES (id,age,name);

    /*查询出t_user表的记录，放⼊user_count中,max_id⽤来存储t_user中最⼩的id*/
    SELECT COUNT(*),max(id) into user_count,max_id from t_user;
END $
/*将结束符置为默认 ';' */
DELIMITER ;

--  【调⽤存储过程：】
/*创建了3个⾃定义变量*/
SELECT @id:=3,@age:=56,@name:='张学友';
/*调⽤存储过程*/
CALL proc2(@id,@age,@name);
```

### 异常

mysql内部异常：sql执行报错(如：违反唯一性约束导致insert失败)
外部异常：sql执行成功，结果和预期不一致

```sql
/*删除存储过程*/
DROP PROCEDURE IF EXISTS proc2;
/*声明结束符为$*/
DELIMITER $

/*创建存储过程*/
CREATE PROCEDURE proc2(a1 int,a2 int)
BEGIN
    /*声明⼀个变量，标识是否有sql异常*/
    DECLARE hasSqlError int DEFAULT FALSE;
    /*在执⾏过程中出任何异常设置hasSqlError为TRUE 【mysql内部异常】*/
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET hasSqlError=TRUE;
    /*保存影响的⾏数*/
    DECLARE v_insert_count INT DEFAULT 0;

    /*开启事务*/
    START TRANSACTION;
    INSERT INTO test1(a) VALUES (a1);
    INSERT INTO test1(a) VALUES (a2);

    /*根据hasSqlError判断是否有异常，做回滚和提交操作*/
    IF hasSqlError THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;

    /*获取上⾯ insert 影响⾏数*/
    /* ROW_COUNT() 可以获取 mysql 中 insert 或者 update 影响的⾏数 */
    select ROW_COUNT() INTO v_insert_count;

    /*业务逻辑校验 【外部异常】 */
    IF v_insert_count=2 THEN
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;
END $
/*结束符置为;*/
DELIMITER
```

## MySQL如何确保数据不丢失

```tip
redo log 是有大小的，有多个，采用环形结构重复利用

当 redo log 不够用(阻塞，先处理 redo log 释放空间后继续)或者系统比较闲的时候，会对redo log 文件中的内容进行处理
```

### 方案一：内存—>磁盘

读取数据页到内存，修改内存数据，把内存中的页数据写入到磁盘

问题：事务执行过程中宕机，数据可靠性没有保障；随机写导致耗时较长

### 方案二：先写日志，再写磁盘

优点：

* 两阶段提交确保 redo log 和 binlog ⼀致性
* 异步处理，处理 redo log 的过程是顺序I/O 做到了高效操作

```
    start trx=全局的事务编号trxid;
        事务操作过程
        执行一个操作，写入一条记录
        ...
        
    prepare trx=全局的事务编号trxid;
        binlog 持久化到磁盘
    end trx=全局的事务编号trxid;
```

日志记录过程：

* mysql 收到 start transactio 后，⽣成⼀个 **全局的事务编号trxid**
* 按顺序循环执行下面两步
  
    + 找到要操作的数据行所在的页，将整页数据加载到内存中
    + 在内存中操作数据，将操作日志(start...end)放入 redo log buffer(内存中的一个区块，可理解为数组结构) 中
    
* mysql 收到 commit 指令，将 redo log buffer 数组中内容写⼊到 redo log ⽂件中
* 事务操作的 binlog 日志 一次性写入，与 redo log 保持一致性
* 返回给客户端更新成功

此时：内存中的数据页被修改，还未同步到磁盘中，也叫**脏页**。修改被记录到 redo log 文件中，不会丢失

日志处理过程：

* 读取 redo log 信息
    
    + 如果 start...**prepare|end** 标签不完整(事务执行失败)，直接跳过；
    + 如果 start...**prepare** 标签完整，trxid 对应的 binlog不存在 则跳过
    + 如果 start...**prepare** 标签完整，trxid 对应的 binlog 存在 则回滚
    + 读取⼀个完整的事务操作信息(start...**prepare|end**)，然后进⾏处理
* 在内存中查找 操作对应的数据页
  
    + 如果 存在，则写入到磁盘中；
    + 如果不存在(如：宕机)，则读取对应数据页到内存中，通过 redo log 修改数据，再写入到磁盘中
* 将 redo log 文件中 对应的**全局的事务编号trxid**(start...end) 占有的空间标记为已处理，这块空间会被释放出来


