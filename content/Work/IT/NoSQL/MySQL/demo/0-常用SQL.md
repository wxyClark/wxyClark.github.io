---
sort: 0
---

# 常用SQL


## 库

```sql
DROP DATABASE if exists 旧库名;
CREATE DATABASE [if not exists] 库名 [default character set = 'utf8mb4'];

```

## 表

```sql
DROP TABLE [if exists] 表名;
CREATE TABLE 表名(
    字段名1 类型[(宽度)] [约束条件] [comment '字段说明'],
    字段名2 类型[(宽度)] [约束条件] [comment '字段说明'],
    字段名3 类型[(宽度)] [约束条件] [comment '字段说明']
)[表的⼀些设置];

--  修改表
ALTER TABLE 表名 rename [to] 新表名;
ALTER TABLE 表名 comment '新的备注信息';
ALTER TABLE 表名 ADD column 列名 类型 [列约束];
ALTER TABLE 表名 MODIFY column 列名 新类型 [约束];
ALTER TABLE 表名 CHANGE column 列名 新列名 新类型 [约束];
ALTER TABLE 表名 DROP column 列名;

--  添加索引
--      如果字段是char、varchar类型，length可以⼩于字段实际长度，
--      如果是blog、text等长⽂本类型，必须指定length。
CREATE [unique] INDEX 索引名称 ON 表名(列名[(length)]);
ALTER TABLE `TABLE_name` ADD PRIMARY KEY |UNIQUE  (`column1`, `column2`, `column3`);
ALTER TABLE `TABLE_name` ADD INDEX  index_name (`column1`, `column2`, `column3`);

--  修改索引
先删除，再创建

--  删除索引
DROP INDEX 索引名称 ON 表名;

--  只复制表结构
CREATE TABLE 表名 LIKE 被复制的表名;

--  复制表结构+数据
CREATE TABLE 表名 [AS] SELECT 字段,... FROM 被复制的表 [WHERE 条件];
例：CREATE TABLE test13 AS SELECT * FROM test11;
```

## DML数据操作

```sql
--  插入数据，如果是字符型或⽇期类型，值需要⽤单引号引起来；如果是数值类型，不需要⽤单引号
INSERT INTO 表名 [(字段,字段)] VALUES (值,值)[,(值,值),(值,值)];

--  更新数据 【建议使用单表更新】
UPDATE 表名 [[AS] 别名] SET [别名.]字段 = 值,[别名.]字段 = 值 [WHERE条件]
例： UPDATE test1 SET a = 1,b=2;
--  多表更新 【不建议】
UPDATE test1 t1,test2 t2 SET t1.a = 2 ,t1.b = 2, t2.c1 = 10 WHERE t1.a
= t2.c1;

--  删除数据 【建议使用单表删除】
DELETE [别名] FROM 表名 [[AS] 别名] [WHERE条件];
例：DELETE t1 FROM test1 t1 WHERE t1.a>100;
--  多表删除 【不建议】
DELETE [别名1,别名2] FROM 表1 [[AS] 别名1],表2 [[AS] 别名2] [WHERE条件];
例：DELETE t1[,t2] FROM test1 t1,test2 t2 H t1.a=t2.c2;
```

### 删除数据前先备份

* 对于由 foreign key 约束引⽤的表，不能使⽤ truncate table，⽽应使⽤不带 WHERE ⼦句的 DELETE 语句
* truncate ⽅式删除之后，⾃增列的值会被初始化
* DELETE ⽅式要分情况（如果数据库被重启了，⾃增列值也会被初始化，数据库未被重启，则不变）
* 删除速度，⼀般来说:	drop > truncate > DELETE

|                    | 定义                             | 是否释放空间       | 保留                                                 | 别名               | 是否会触发trigger | 生效时间          |
| ------------------ | -------------------------------- | ------------------ | ---------------------------------------------------- | ------------------ | ----------------- | ----------------- |
| drop tableName     | 删除表的内容、定义、索引、触发器 | 释放空间           | 存储过程、函数，但状态会变为 invalid                 | 删除表             | 不会              | ⽴即⽣效            |
| truncate tableName | 清空表的内容                     | 释放空间           | 表的定义、索引、触发器、存储过程、函数               | 清空表中的所有数据 | 不会              | ⽴即⽣效            |
| DELETE             | 删除表中的数据，每次删除一行     | 保留日志，方便回滚 | 表的定义、索引、触发器、存储过程、函数、未删除的数据 | 删除表中的行       | 会                | 事务提交之后才⽣效 |


## 查询

```sql
--  如果使用了 GROUP BY, 则 SELECT 后⾯出现的列必须在 group by中或者必须使⽤聚合函数   
SELECT 
    A.xx_id, A.xx_code, B.yy_code, count(A.id) as cnt,
    CASE <表达式>
        WHEN <值1> THEN <操作>
        WHEN <值2> THEN <操作>
        ...
        ELSE <操作>
    END CASE;
    CASE <表达式>
        WHEN <条件1> THEN <命令>
        WHEN <条件2> THEN <命令>
        ...
        ELSE <命令>
    END CASE;
    
    --  一对多的数据，groupBy后 拼接在一起
    IFNULL(GROUP_CONCAT(TAG.goods_sn, ':', TAG.tag, ';'),'') as '标签'
FROM table_a AS A
LEFT JOIN table_b AS B ON A.xx_id = B.xx_id
--  WHERE 条件顺序：
--      =匹配、IN匹配(建议小于500个元素)、NOT IN()、
--      范围匹配(>、<、>=、<=)、区间查询(BETWEEN AND， 等价于 >= AND <=)
--      NULL值专用查询：NOT NULL、IS_NULL
--      LIKE 'xx%'匹配，LIKE '%yy'匹配，%可以匹配⼀个到多个任意的字符，_可以匹配任意⼀个字符
--      不等匹配(推荐使用<>)
--      安全等于<=>(可用于null值比较，如： where t.a<=>null) 【不建议使用】
WHERE A.xx_code IN (code1,code2,code3) AND B.yy_code = code4
--  GROUP BY保证分页完整性(每页数据量相同), 
--  HAVING 对分组之后的数据进⾏过滤(HAVING count(id)>=2 或 HAVING cnt >= 2)
--  使用 GROUP BY 在 SELECT 中应有 聚合函数(count、sum、)
GROUP BY A.id,B.id [HAVING group_condition]
--  排序尽可能使用左表的字段并命中索引，
--  排序要避免二义性(排序规则使用的字段联合起来具有唯一性)，
--  默认 ASC 可省略
ORDER BY A.create_at ASC
--  LIMIT 中不能使用表达式，只能跟明确的正整数
--  命令行脚本，尽可能使用 WHERE条件 使得 偏移量 = 0
--  偏移量默认 = 0 可省略
LIMIT [0,]20
```

CASE WHEN...THEN

```sql
SELECT id, 
    CASE
        WHEN cast(`status` AS SIGNED) < 45 
            THEN '1' 
        WHEN cast(`status` AS SIGNED) > 44 AND vacant_time IS NOT NULL AND vacant_time != '' 
            THEN '3'
        WHEN cast(`status` AS SIGNED) > 44 AND move_date IS NOT NULL AND move_date != '' 
            THEN '2'
        WHEN cast(`status` AS SIGNED) > 44 
            THEN '4'
        ELSE '99'
    END [CASE] AS `status`
    -- =前后不用有空格
    CASE 
        WHEN SPU.status='1' THEN '待做货'
        WHEN SPU.status='2' THEN '打版中'
        WHEN SPU.status='3' THEN '做货成功'
        WHEN SPU.status='4' THEN '移除'
        WHEN SPU.status='5' THEN '做货中'
        ELSE SPU.status
    END  as 'SPU状态',
FROM t_household 
WHERE  del_flag = '0';
```

mysql查询一个字段在哪些表中用到

```sql
SELECT 
    TABLE_SCHEMA as '数据库',
    TABLE_NAME as '表' ,
    COLUMN_NAME as '字段'
FROM information_schema.COLUMNS
WHERE COLUMN_NAME ='字段名';
```