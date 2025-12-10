---
sort: 0
---



# MySQL基础


| 种类    | 完整名称  | 解释 | 解释 | 使用者 |
| ---- | ---- |---- |---- |---- |
| DCL |  Data Control Language | 数据库【控制】语言 | 权限分配、回收 | DBA |
| DDL |  Data Definition Language | 数据库【定义】语言 | 建表、改结构、索引 <br> create、drop、alter | DBA、开发者 |
| DML |  Data Manipulation Language | 数据库【操作】语言 | 增、删、改 <br> insert 、update、delete | 开发者 |
| DQL |  Data Query Language | 数据库【查询】语言 | 查 <br> select | 开发者 |
| TCL |  Transaction Control Language | 【事务】控制语⾔ | set autocommit=0 <br> start transaction <br> savepoint <br> commit <br >rollback | 开发者 |

declare创建的局部变量常⽤于存储过程和函数的创建中

## 版本差异

## 概念

### 主键
### 外键

    推荐逻辑外键

## 范式

## 存储引擎

## 字段规则
最小原则

## 索引
### 唯一索引
### 联合索引
最左匹配
### 普通索引

## 事务


## 函数

| 函数 | 用途 | 示例 | 结果 |
| ---- | ---- | ---- | ---- | 
| sqrt(x) | 开平方 | sqrt(120) | 10.954451150103322 | 
| mod(x,y) | 求余数 | mod(15.5,3) | 0.5 | 
| ceil(x) <br> ceiling(x) | 向上取整 <br> 返回值转化为⼀个 BIGINT | ceil(-2.5) <br>  ceiling(2.5) | -2 <br> 3 | 
| floor(x) | 向下取整 | floor(5.66) | 5 |
| round | 四舍五⼊函数 | round(-6.66,1) <br> round(3.33,3) <br> round(88.66,-1) <br> round(88.46,-2) | -6.7 <br> 3.330 <br> 90 <br> 100 |
| rand() | ⽣成⼀个随机数(0,1) | rand() <br> rand(10) <br> ceil(rand() * 100) | 随机数 <br> 指定参数生成固定数值(0,1)  <br> 生成 (0, 100] 之间的随机数|
| sign | 返回参数的符号 |  sign(-6) <br> sign(0) <br> sign(34) | -1 <br>  0 <br>  1 |
| pow <br> power | 次⽅函数 | pow(5,-2) <br> pow(10,3) <br> pow(100,0);  <br>  <br> power(4,3) <br> power(6,-3) | 0.04 <br> 1000 <br> 1  <br> <br> 64 <br> 0.004629629629629629|
| pi() | 圆周率 | pi() | 3.141593 |
| sin(x) | 正弦函数 <br> x为弧度值 |  sin(1) <br>  sin(0.5*pi()) | 0.8414709848078965 <br> 1 |
| length | 字符长度 <br> UTF8 汉字占3个字节 |  length('javacode2022') <br> length('路⼈甲Java') <br> length('路⼈'); | 12, 13, 6 |
| concat(colum1, column2, string) | 合并字符串, NULL不能参与 |  concat('路⼈甲','java') <br> concat('路⼈甲',null,'java') |  路⼈甲java <br> NULL |
| INSERT(s1, x, len, s2) | 返回字符串 s1, 用 s2 替换 s1 从 x 位置起len 个字符长的字符串 | select <br> insert('路⼈甲Java', 2, 4, '\*\*') AS col1, <br> insert('路⼈甲Java', -1, 4,'\*\*') AS col2, <br> insert('路⼈甲Java', 3, 20,'\*\*') AS col3; | <br> 路**va <br> 路⼈甲Java <br> 路⼈\*\* |
| lower | 将字⺟转换成⼩写 | lower('路⼈甲JAVA') | 路⼈甲java |
| upper | 将字⺟转换成⼤写 | upper('路⼈甲java') | 路⼈甲JAVA |
| left(s, n) | 从左侧截取字符串 <br> 返回字符串 s 最左边的 n 个字符 | select left('路人甲JAVA',2), <br> left('路人甲JAVA',4), <br> left('路人甲JAVA',-1); | '路⼈' <br>'路⼈甲J' <br>'' |
| right(s, n) | 返回字符串 s 最右边的 n 个字符 | select right('路人甲JAVA',1), <br> right('路人甲JAVA',6), <br> right('路人甲JAVA',-1); | 'A' <br> '人甲JAVA' <br>''|
| trim(s) | 删除字符串 s 两侧的空格 | trim(' 路⼈甲Java ') | '路人甲Java' |
| replace(s, s1, s2) | 使⽤字符串 s2 替换字符串 s 中所有的字符串 s1 | replace('路人甲PHP', 'PHP', 'Go') | '路人甲Go' |
| substr <br> substring | 截取字符串 | substr(str,pos) <br> substr(str from pos) <br> substr(str,pos,len) <br> substr(str from pos for len)   |  |
| reverse(s) | 反转字符串 | reverse('路⼈甲Java') | avaJ甲⼈路 |
| curtime() <br> current_time() | 获取系统当前时间 | curtime() <br> current_time() | 18:08:38 <br> 18:08:38 | 
| now() <br> sysdate() | 获取当前⽇期时间 | now() <br> sysdate() | 2022-02-07 18:09:08 <br> 2022-02-07 18:09:08 | 
| unix_timestamp() | 获取UNIX时间戳 | unix_timestamp() <br> unix_timestamp(now()) <br> unix_timestamp('2022-02-22 22:22:22') | 1644228671 <br> 1644228671 <br> 1645539742 | 
| from_unixdme(stamp, format) | 时间戳转⽇期 | FROM_UNIXTIME(1645539742, '%Y-%m-%d %H:%i:%s') | '2022-02-22 22:22:22' | 
| month(d) | 获取指定⽇期的⽉份 <br> 参数不能为空 | month('2017-12-15') <br> month(now())  | 12 <br> 2 | 
| monthname(d) | 获取指定⽇期⽉份的英⽂名称 <br> 参数不能为空 | monthname('2017-12-15') <br> monthname(now()) | December <br> February | 
| dayname(d) | 获取指定⽇期的星期名称 <br> 参数不能为空 | dayname('2022-02-22') <br> dayname(now()) | Tuesday <br> Monday | 
| week() | 获取指定⽇期是⼀年中的第⼏周 |  |  | 
| dayofweek(d) | 获取⽇期对应的周索引 <br> 1表示周日，2表示周一，7表示周六 | dayofweek(now()) | 2 | 
| dayofyear(d) | 获取指定⽇期在⼀年中的位置 |  |  | 
| dayofmonth(d) | 获取指定⽇期在⼀个⽉的位置 |  |  | 
| year(d) | 获取年份 | year(now())<br>year('2019-01-02') | 2022 <br> 2019 | 
| timetosec() | 将时间转换为秒值 <br> ⼩时×3600 + 分钟 × 60 + 秒” |  time_to_sec('15:15:15') | 54915 | 
| sectodme() | 将秒值转换为时间格式 | sec_to_time(100) <br>  sec_to_time(10000) | 00:01:40 <br>  02:46:40 | 
| ---- | --- | ---- | ---- | 
| datediff(date1, date2) | 获取两个⽇期的时间间隔天数 <br> date1 和 date2 为⽇期或 date-time 表达式 |  datediff('2017-11-30','2017-11-29') <br> datediff('2017-11-30','2017-12-15') | 1 <br> -15 | 
| A | B | C | D | 


## 流程控制语句

* if 函数    if(条件表达式,值1,值2); **条件表达式为** true 的时候，返回 **值1**，否则返回 **值2**。 常用语 select
* case 语句  case when then [when then] else end    主要⽤在select、begin end中,begin end中使⽤不能省略case 例： end case
* if 结构
* while 循环
* repeat 循环   类似 do while
* loop 循环     类似 while(true){} 死循环
* 循环体控制语句    continue、break、iterate(跳过)、leave(代码段前面加标签，退出对应的带没段)

## 游标 Cursor

```tip
游标使⽤完毕之后⼀定要关闭。

⼀个 begin end 中只能声明⼀个游标
```

* 用途：通过游标的⽅式来遍历select查询的结果集，然后对每⾏数据进⾏处理
* 场景：游标只能在存储过程和函数中使⽤
* 原理：游标相当于⼀个指针，这个指针指向select的第⼀⾏数据，可以通过移动指针来遍历后⾯的数据

```sql
--  【声明游标】
DECLARE 游标名称 CURSOR FOR 查询语句;

--  【打开游标】
OPEN 游标名称;

--  【遍历游标】
FETCH 游标名称 INTO 变量列表;
--  取出当前⾏的结果，将结果放在对应的变量中，并将游标指针指向下⼀⾏的数据。
--  当调⽤fetch的时候，会获取当前⾏的数据，如果当前⾏⽆数据，会引发mysql内部的NOT FOUND错误。

--  【关闭游标】
CLOSE 游标名称;
```

示例：写⼀个函数，计算test1表中a、b字段所有的和。

```sql
/*删除函数*/
DROP FUNCTION IF EXISTS fun1;
/*声明结束符为$*/
DELIMITER $
/*创建函数*/
CREATE FUNCTION fun1(v_max_a int)
    RETURNS int
    BEGIN
        /*⽤于保存结果*/
        DECLARE v_total int DEFAULT 0;
        /*创建⼀个变量，⽤来保存当前⾏中a的值*/
        DECLARE v_a int DEFAULT 0;
        /*创建⼀个变量，⽤来保存当前⾏中b的值*/
        DECLARE v_b int DEFAULT 0;
        /*创建游标结束标志变量*/
        DECLARE v_done int DEFAULT FALSE;

        /*创建游标*/
        DECLARE cur_test1 CURSOR FOR SELECT a,b from test1 where a<=v_max_a;
        /*设置游标结束时v_done的值为true，可以v_done来判断游标是否结束了*/
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done=TRUE;
        /*设置v_total初始值*/
        SET v_total = 0;
        
        /*打开游标*/
        OPEN cur_test1;

        /*使⽤Loop循环遍历游标*/
        a:LOOP
            /*先获取当前⾏的数据，然后将当前⾏的数据放⼊v_a,v_b中，如果当前⾏⽆数据，v_done会被置为true*/
            FETCH cur_test1 INTO v_a, v_b;
            /*通过v_done来判断游标是否结束了，退出循环*/
                if v_done THEN
                    LEAVE a;
                END IF;
            /*对v_total值累加处理*/
            SET v_total = v_total + v_a + v_b;
        END LOOP;

        /*关闭游标*/
        CLOSE cur_test1;

        /*返回结果*/
        RETURN v_total;
    END $
/*结束符置为;*/
DELIMITER ;
```

示例：嵌套游标
```sql
/*删除存储过程*/
DROP PROCEDURE IF EXISTS proc1;
/*声明结束符为$*/
DELIMITER $
/*创建存储过程*/
CREATE PROCEDURE proc1()
    BEGIN
        /*创建⼀个变量，⽤来保存当前⾏中a的值*/
        DECLARE v_a int DEFAULT 0;
        /*创建游标结束标志变量*/
        DECLARE v_done1 int DEFAULT FALSE;
        /*创建游标*/
        DECLARE cur_test1 CURSOR FOR SELECT a FROM test2;
        /*设置游标结束时v_done1的值为true，可以v_done1来判断游标cur_test1是否结束了*/
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done1=TRUE;

        /*打开游标*/
        OPEN cur_test1;
        /*使⽤Loop循环遍历游标*/
        a:LOOP
            FETCH cur_test1 INTO v_a;
            /*通过v_done1来判断游标是否结束了，退出循环*/
            if v_done1 THEN
                LEAVE a;
            END IF;

            /* 第二层 begin end,【每层只能有一个游标】 */
            BEGIN
                /*创建⼀个变量，⽤来保存当前⾏中b的值*/
                DECLARE v_b int DEFAULT 0;
                /*创建游标结束标志变量*/
                DECLARE v_done2 int DEFAULT FALSE;
                /*创建游标*/
                DECLARE cur_test2 CURSOR FOR SELECT b FROM test3;
                /*设置游标结束时v_done1的值为true，可以v_done1来判断游标cur_test2是否结束了*/
                DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done2=TRUE;

                /*打开游标*/
                OPEN cur_test2;
                /*使⽤Loop循环遍历游标*/
                b:LOOP
                    FETCH cur_test2 INTO v_b;
                    /*通过v_done1来判断游标是否结束了，退出循环*/
                    if v_done2 THEN
                        LEAVE b;
                    END IF;
                    /*将v_a、v_b插⼊test1表中*/
                    INSERT INTO test1 VALUES (v_a,v_b);
                END LOOP b;

                /*关闭cur_test2游标*/
                CLOSE cur_test2;
            END;
        END LOOP;
        /*关闭游标cur_test1*/
        CLOSE cur_test1;
    END $
/*结束符置为;*/
DELIMITER ;
```