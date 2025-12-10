---
sort: 8
---

# query查询过程

```sql
SELECT A.id, B.id
--  内链接 WHERE 条件必须同时满足
FROM table_a AS A, table inner I
LEFT JOIN table_b AS B 
    --  ON 条件的过滤 必须满足，外链接 WHERE条件的过滤不满足时，B表字段以NULL显示
    ON B.idx_key = A.idx_key AND (contition)
WHERE 
    --  条件顺序：先精准匹配，后范围，最后模糊；先索引，后普通列；先主表，后副表；
    --  子查询
    (A.id, A.column) IN (SELECT min(id), max(column) FROM table_a as T)
    AND B.column_1 IN (限制枚举值在500以内，推荐分页数为200)
    EXISTS (condition)
GROUP BY [构成唯一标识的 分组条件]
HAVING (聚合后的过滤条件)
ORDER BY
LIMIT $offset,$limit
```

## 总流程图
```mermaid
graph TB

    C1==客户端/服务器<br>通信协议==> S1
    RS==返回数据==>C1

    S9--API查询接口-->E

    E--返回数据-->C{是否开启缓存}

    C-->M(是<br>生成缓存)-->S2
    C--否,返回-->RS
    M-->RS
    

    subgraph 客户端

        C1((请求))

    end

    subgraph MySql Server

        S1{连接器<br><br>身份认证<br>权限判断}-->S2[查询缓存]

        S2--命中-->RS>结果集 / 影响行数]
        S2-.->S21(大小写敏感的哈希表)-->S211(show variables like 'query_cache%')
        S2--未命中-->S3[解析器]
        S3--语法解析-->S4>解析树]

        S4-->S5[预处理器]-->S6>新解析树]

        S6-->S7[基于成本的查询优化器]
        S7-.->S71(优化策略)
        S71-->S711[静态优化<br>编译时优化]-->S7111(直接对解析树进行分析<br>并完成优化)
        S7111-.->S71111(将where条件转换成另一种等价形式<br> 一次优化永久有效,常数变化不受影响)

        S71-->S712[动态优化<br>运行时优化]-->S7121(和查询的上下文有关<br>也可能和很多其他因素有关)
        S7121-.->S71211(如where条件中的取值<br>索引中条目对应的数据行数<br>需要每次查询的时候重新评估)


        S7-.->S72(优化类型)-->S721((请看下图))

        S7-->S8>执行计划]

        S8-->S9[查询执行引擎]

    end

    subgraph 存储引擎
        E[存储引擎]
        E -.-> E1[InnoDB]
        E -.-> E2[MyISAM]
        E -.-> E3[...]

        E1--> D1((数据))
        E2--> D1
        E3--> D1
    end

    style S1 stroke:#F00,stroke-width:4px;   
    style S7 stroke:#F00,stroke-width:4px;  
    style RS stroke:#F00,stroke-width:4px;

    style S721 stroke:#30F,stroke-width:4px;  

    style S711 stroke:#30F,stroke-width:2px;  
    style S712 stroke:#30F,stroke-width:2px;  

    style C1 fill:#2ff,fill-opacity:0.1,stroke:#faa,stroke-width:4px
    style S21 stroke:#000,stroke-width:4px;
```
### 优化类型
```mermaid
graph LR
    S72(优化类型)
            S72-->S721[重新定义关联表的顺序]-.->S7211(和SQL编写顺序未必一致)
            S72-->S722[将外连接转化成内连接]-.->S7221(MySQL会重写等价的内连接)
            S72-->S723[使用等价变换规则]-.->S7231(NOT条件转换,恒等 恒不等判定)-->S72311>EXISTS比NOT高效]
            S72-->S725[预估并转化为常数表达式]-.->S7251>不在MySQL中做数据计算]
            S72-->S726[覆盖索引扫描]-.->S7261(索引的叶子存了PK值,无需查询对应的数据行)
            S72-->S727[子查询优化]-.->S7271(转换成一种效率更高的形式)-->S72711>IN常量列表比子查询高效]
            S72-->S728[提前终止查询]-.->S7281>使用limit]
            S72-->S729[等值传播]
            S72-->S72X[列表in的比较]
            S72X-.->S72X1(MySQL将in列表中的数据先进行排序)
            S72X-.->S72X2(然后通过二分查找的方式来确定列表中的值是否满足条件<br>复杂度为logN)-->S72X21>MySQL中in比or高效]
            S72X-.->S72X3(而等价转换成or的查询的复杂度为N)
            S72-->S724[优化count min max]-.->S7241(索引和列是否为空通常可以帮助MySQL优化这类表达式)-->S72411((请看下图))

            style S72311 stroke:#F00,stroke-width:4px;
            style S7251 stroke:#F00,stroke-width:4px;
            style S72411 stroke:#30F,stroke-width:4px;  
            style S72711 stroke:#F00,stroke-width:4px;  
            style S7281 stroke:#F00,stroke-width:4px;  
            style S72X21 stroke:#F00,stroke-width:4px;
```
### count()、max()、min() 优化
```mermaid
graph TB
S724[优化count min max]-.->S7241(索引和列是否为空通常可以帮助MySQL优化这类表达式)
S7241-->S72411[最小值,只需要查询对应B-tree索引最左端的记录--1行数据]
S72411-->S724111(explain中就可以看到 select tables optimized away)
S724111-->S7241111(表示优化器已经从执行计划中移除了该表,并以一个常数取而代之)

S7241-->S72412[count*,通常也可以使用存储引擎提供的一些优]
S72412-->S724121(MyISAM维护了一个变量来存放数据表的行数)
```

count 会忽略 limit条件

WHERE 条件 归类

| 类 | 用途 | 提取规则  |
| ----- | ------ | ------- |
| (Index Key)First Key | 定位索引查找的起始条件 | =、>= 、> |
| (Index Key)Last Key | 定位索引查询的终⽌条件 | =、<=、< |
| Index Filter | 在索引范围内对索引列过滤 | >=、>、<、<=、!= <br> 在完成Index Key的提取之后 <br> 提取符号条件的记录 |
| Table Filter | 所有不属于索引列的查询条件 | 如：两个字段的比较 |

## Explain 查询分析器

### 概念

### 列-注释

| 列 | 意义 | 备注  |
| ----- | ------ | ------- |
| id | ------ | ------- |
| select_type | ------ | ------- |
| table | ------ | ------- |
| partitions | ------ | ------- |
| type | ------ | ------- |
| possible_keys | 可能会⾛的索引 | ------- |
| key | 实际上⾛的索引 | ------- |
| key_len | 索引长度 | ------- |
| ref | ------ | ------- |
| rows | 扫描行数 | ------- |
| filtered | ------ | ------- |
| Extra | ------ | ------- |

range
触发条件：只有在使用主键、单个字段的辅助索引、多个字段的辅助索引的最后一个字段进行范围查询才是 range

## 缓存参数设置

| 参数 | 用途 | 备注  |
| ----- | ------ | ------- |
| query_cache_limit | MySQL能够缓存的最大结果 | 如果超出,则增加 Qcache_not_cached的值,并删除查询结果 |
| query_cache_min_res_unit  | 分配内存块时的最小单位大小  |  |
| query_cache_size | 缓存使用的总内存空间大小,单位是字节 | 必须是1024的整数倍，否则实际分配和配置值不同 |
| query_cache_type | 是否打开缓存 | OFF: 关闭 ON: 总是打开  |
| query_cache_wlock_invalidate | 如果某个数据表被锁住,是否仍然从缓存中返回数据 | 默认是OFF,表示仍然可以返回 |

## 联表

* 内连接分为3种：
  
    FROM a INNER JOIN b 
    FROM a JOIN b 
    FROM a b

* inner Join on 条件字段为 null 的数据**会过滤掉**


* 外连接分为2种：

    左外链接：FROM 主表 LEFT JOIN b JOIN 从表
    右外连接：FROM 从表 RIGHT JOIN b JOIN 主表

* LEFT JOIN ON 条件从表数据为 null 的数据**不会过滤**
* LEFT JOIN ON 条件 剪切到 WHERE 后面； 从表数据为 null 的数据**【会被过滤掉】**，导致 NULL 判定取不到数据
> ON 条件 【可以取到】 左表有,右表没有的数据
```sql
SELECT V.company_id, V.product_sn, V.goods_sn, V.STATUS, T.tag
FROM product_sku V
LEFT JOIN ic_product_tag T ON (V.goods_sn = T.goods_sn AND V.company_id = T.company_id)
WHERE T.tag IS NULL  --【ON条件 不过滤 NULL记录】
```
> ON 条件 改为WHERE 条件 【取不到】 左表有,右表没有的数据
```sql
SELECT V.company_id, V.product_sn, V.goods_sn, V.STATUS, T.tag
FROM product_sku V
LEFT JOIN ic_product_tag T ON (V.goods_sn = T.goods_sn)
WHERE T.tag IS NULL AND V.company_id = T.company_id  --【ON条件改 WHERE 条件】
```

## 子查询

```tip
⼀般来说，能⽤ exists 的⼦查询，绝对都能⽤ in 代替，所以 exists ⽤的少。推荐使用 in 具体值

【大坑】not in 的情况下，⼦查询中列的值为 NULL 的时候，外查询的结果为空。

in 子查询、 exists 的⼦查询 都推荐使用 join 方式 加过滤条件解决
```

⼦查询的执⾏优先于主查询执⾏，因为主查询的条件⽤到了⼦查询的结果。

| 名称      | 结果集              | 用于                               | 用法                                                                                                      |
| --------- | ------------------- | ---------------------------------- | --------------------------------------------------------------------------------------------------------- |
| 标量⼦查询 | ⼀⾏⼀列               | select后⾯ <br> where或having后⾯    | >、<、>=、<=、=、<>、!=、in、not in                                                                       |
| 列⼦查询   | ⼀列多⾏              | where或having后⾯                   | in、not in、any、some、all <br> a>some(10,20,30) 大于任意一个值 <br> a>min(10,20,30) <br> a>max(10,20,30) |
| ⾏⼦查询    | ⼀⾏多列              | where或having后⾯                   | in、not in、any、some、all <br> a>some(10,20,30) 大于任意一个值 <br> a>min(10,20,30) <br> a>max(10,20,30) |
| 表⼦查询   | 多⾏多列<br>一行多列 | from后⾯(必须起别名) <br> <br> exists(相关⼦查询)后⾯ | 各种 join <br> <br> 完整的查询语句，返回 1 或 0 |

⾏⼦查询（⼦查询结果集⼀⾏多列）
```sql
--  ⽅式1
SELECT *
FROM employees a
WHERE a.employee_id = (SELECT min(employee_id) FROM employees)
    AND a.salary = (SELECT max(salary) FROM employees);

--  ⽅式2
SELECT *
FROM employees a
WHERE (a.employee_id, a.salary) = 
    (SELECT min(employee_id), max(salary) FROM employees)

--  ⽅式3
SELECT *
FROM employees a
WHERE (a.employee_id, a.salary) in 
    (SELECT min(employee_id), max(salary) FROM employees);
```

* 外部查询条件不能够下推到复杂的视图或子查询的情况有：
> 1、聚合子查询；
>
> 2、含有 LIMIT 的子查询；
>
> 3、UNION 或 UNION ALL 子查询；
>
> 4、输出字段中的子查询；

## JSON

[关于json函数的官方文档](https://dev.mysql.com/doc/refman/5.7/en/json.html)
[关于key存在的官网解释](https://dev.mysql.com/doc/refman/5.7/en/json-search-functions.html)

```sql
--  返回的一般都是true or false 或者 1 和 0
json_contains_path(json_doc, one_or_all, paths)
--  json_doc就是json数据
--  paths是指要找的key，可以传入多个的key参数
--  one_or_all指一个值是one表示找出paths参数中的任意一个，all表示找出全部

--  解析json一维数组 是否含有position
select json_contains_path("{'name':'xxx', 'age':'保密','position':'php 工程师'}",
 'one', '$.position')
--  返回的结果是1

--  解析json一维数组 是否同时含有position，age
select json_contains_path("{'name':'xxx', 'age':'保密','position':'php 工程师'}",
 'all', '$.position', '$.age');
--  返回的结果是1

--  解析二维json数组的某个key
SELECT *
FROM TABLE_NAME T
WHERE JSON_CONTAINS(T.json_column,JSON_OBJECT("index_name", 'index_value'))

--  判定json字段是否为空数组
SELECT *
FROM TABLE_NAME T
WHERE T.json_column  like '[]'

--  判定json数组指定下表的元素是否存在
SELECT uniq_code, json_extract(column_name,'$.key')
FROM table_name
where JSON_EXTRACT(column_name,'$.key')  IS NULL
-- IS NOT NULL
SELECT uniq_code, json_extract(column_name,'$.key')
FROM table_name
where JSON_EXTRACT(column_name,'$.key') > ''

-- json字段的IN条件是数值数组时
$array = [];
if (count($array) == 1) {
    $string = "'".current($array)."'";
} else {
    foreach ($array as &$item) {
        $string = implode(',', (int)item);
    }
    unset($item);
}

SELECT uniq_code, json_extract(column_name,'$.key')
FROM table_name
where JSON_EXTRACT(column_name,'$.key') in ($string)


-- 需求：查找 config JSON字段（对象类型）中 fieldModels（数组类型）数组字段中 valueMapping（整形）值等于 17 的记录
-- 表字段：id, config
-- config字段格式：
/*
{
    "fieldModels": [{
        "key": 0,
        "guid": "1",
        "field": "Id",
        "dataType": 1,
        "showName": "标识",
        "textFormat": "",f
        "valueMapping": 17
    }, {
        "key": 1,
        "guid": "2",
        "field": "orderid",
        "dataType": 0,
        "showName": "orderid",
        "textFormat": "",
        "valueMapping": -1
    }
}
*/
SELECT id, config FROM `sql_model` 
WHERE JSON_CONTAINS(JSON_EXTRACT(`config`,'$.fieldModels'), JSON_OBJECT('valueMapping', @valueMapping)) > 0;

-- 查询JSON字段(数组)中是否包含某个值
SELECT * FROM menus
WHERE JSON_CONTAINS(support_coop_mode, '3');

-- 时间格式
SELECT
  id, JSON_EXTRACT( origin_data, '$.completedAt' ) as completedAtTime , CONVERT_TZ(TRIM('"' from JSON_EXTRACT( origin_data, '$.completedAt' )),'+00:00','+08:00') as completedAt,
  JSON_EXTRACT( origin_data, '$.createdAt' ) as createdAtTime , CONVERT_TZ(TRIM('"' from JSON_EXTRACT( origin_data, '$.createdAt' )),"+08:00","+08:00") as createdAt,
  origin_data
FROM
  `shopify_checkouts`
WHERE
    CONVERT_TZ(TRIM('"' from JSON_EXTRACT( origin_data, '$.createdAt' )),"+08:00","+08:00") > CONVERT_TZ(TRIM('"' from JSON_EXTRACT( origin_data, '$.completedAt' )),'+00:00','+08:00')
  limit 10
```

* JSON数组中是否包含某个值
> JSON_CONTAINS() 用于判断一个 JSON 文档是否包含另一个 JSON 文档作为子文档
```sql
SELECT *  
FROM users  
WHERE JSON_CONTAINS(info->'$.addresses', '{"city": "New York"}', '$.addresses[*]');
```
```php
$uq = 'unique_code';
$query = $this->model->where('uq', $uq);
if (!empty($params['duty_handler_arr'])) {
    $sub_query_arr = [];
    foreach ($params['duty_handler_arr'] as $duty_handler) {
        $sub_query_arr[] = " JSON_CONTAINS(duty_handler, '{$duty_handler}') ";;
    }
    $query->whereRaw('('.implode(' or ', $sub_query_arr).')');
}
```

* 复杂json查询
> 多维对象数据下 某个对象数组 下的某个key值条件
```mysql
SELECT
  id, xx_code, xx_info
FROM
  xx_order
WHERE
  `id` > 0  AND (
  JSON_CONTAINS( xx_info -> '$[0].rows[*].xx_key', JSON_ARRAY( 'xx_value' )) OR
  # JSON_ARRAY( 'xx_value' ) 与 '"xx_value"' 写法 等价
  JSON_CONTAINS( xx_info -> '$[1].rows[*].xx_key', '"xx_value"')
  )
ORDER BY id ASC LIMIT 100 OFFSET 0

# xx_info数据示例：
# [
#     
#     {
#         "rows":[{"xx_no":"202409150044","xx_name":"xx_name1"},{"xx_no":"202409150045","xx_name":"绿蓝"}],
#         "columns":[{"key":"xx_no","hide":true,"value":"xx编号","required":false},{"key":"xx_name","hide":true,"value":"xx代码","required":false}]
#     },
#     {
#         "rows":[{"xx_no":"202409060044","xx_name":"xx_name2"},{"xx_no":"202308230002","xx_name":"通用"},{"xx_no":"202308230003","xx_name":"通用"},{"xx_no":"202409150047","xx_name":"墨绿色"},{"xx_no":"202308231597","xx_name":"米白色"}],
#         "columns":[{"key":"xx_no","hide":true,"value":"xx编号","required":false},{"key":"xx_name","hide":true,"value":"xx代码","required":false}]
#     },
#     {
#         "rows":[],
#         "columns":[{"key":"unit","hide":false,"value":"单位","required":false}]
#     }
# ]

## 优化效率
SELECT
  id, xx_code, xx_info
FROM
  (
    SELECT
      id, xx_code, xx_info,
      JSON_CONTAINS(xx_info -> '$[0].rows[*].xx_key', '"xx_value"') AS contains_0,
      JSON_CONTAINS(xx_info -> '$[1].rows[*].xx_key', '"xx_value"') AS contains_1
    FROM
      xx_order
    WHERE
      `id` > 0
  ) AS subquery
WHERE
  contains_0 OR contains_1
ORDER BY id ASC
LIMIT 100 OFFSET 0;
```

* json为空或空数组
```sql
SELECT *  
FROM table_name  
WHERE JSON_LENGTH(json_column) = 0
```


## 排序

```tip
尽可能使得排序使用 主表的索引列

确保排序规则具有唯一性，在必要的时候追加 unique 列 或 group by 列 左右排序规则
```

```danger
MySQL8以下 混合排序 ASC、DESC 无法完全利用索引

特例：某个排序字段只要少数几个值 可以取巧
```

```sql
SELECT *
FROMmy_order o
INNER JOIN my_appraise a ON a.orderid = o.id
ORDER BY a.is_reply ASC, a.appraise_time DESC
LIMIT  0, 20
```
由于 is_reply 只有0和1两种状态，按照下面的方法重写后，执行时间骤降
```sql
SELECT *
FROM (
    (
        SELECT *
        FROM my_order o
        INNER JOIN my_appraise a ON a.orderid = o.id AND is_reply = 0
        ORDER BY appraise_time DESC LIMIT  0, 20
    )
    UNION ALL
    (
        SELECT *
        FROM my_order o
        INNER JOIN my_appraise a ON a.orderid = o.id AND is_reply = 1
        ORDER BY appraise_time DESC LIMIT  0, 20)
) t
ORDER BY is_reply ASC, appraisetime DESC 
LIMIT  20;
```

## 跨表更新

```sql
UPDATE table_a AS A
LEFT JOIN table_b AS B ON A.f_key = B.f_key
SET A.column_c = B.column_c
WHERE A.column_d condition AND B.column_e condition
```

## 刷数据

```danger
铁律：【刷数据之前先备份整个表】
```

```sql
insert into table_name(field1,field2,field3)
SELECT colm1,colm2,colm3 FROM t1 WHERE condition 
```

* 跨多表统计并更新数据
```sql
UPDATE analysis_goods_sale T
    
JOIN (
    SELECT
        a.tenant_id,a.goods_sn,
        sum(quantity) quantity,
        sum(sales) sales,
        sum( a.amount ) buy_price
        left(c.payment_date,10) `analysis_date`,
        d.account_code,
        e.product_sn
    FROM (
        SELECT id, tenant_id, goods_sn, quantity,buy_price, account_code,
        dispatched_quantity,order_code,product_sn,is_deleted,
        if (buy_price > 0, quantity, 0) sales,
        buy_price * quantity amount,
        FROM oms_order_product_sku
    ) a
    LEFT JOIN `oms_order` c ON  a.tenant_id=c.tenant_id AND a.order_code=c.order_code  AND a.account_code=c.account_code
    LEFT JOIN `c_accounts` d ON c.tenant_id=d.tenant_id AND c.account_code=d.account_code AND a.account_code=d.account_code
    LEFT JOIN `ic_product_variation` e ON e.goods_sn=a.goods_sn AND e.tenant_id=a.tenant_id
    WHERE c.payment_date >= '2021-07-22 00:00:00' and c.payment_date <= '2021-07-22 23:59:59' AND a.is_deleted = 2 and c.order_status IN (1,2,3)
    GROUP BY
        a.tenant_id,
        d.account_code,
        a.goods_sn,
        `analysis_date`
) S ON T.company_id = S.company_id AND T.product_sn = S.product_sn AND T.goods_sn = S.goods_sn AND T.payment_date = S.analysis_date
    
SET T.sales = S.sales, T.sales_amount = S.pay_price
WHERE 
    T.company_id = S.company_id AND T.account_code = S.account_code 
    AND T.product_sn = S.product_sn AND T.goods_sn = S.goods_sn
    AND T.payment_date = S.analysis_date
```

* 替换数据

```danger
REPLACE INTO 主键匹配，有则删除 然后插入；无则插入

当有两个脚本处理同一个表的数据时，第一个脚本用REPLACE INTO方式更新

则第二个脚本的更新过的数据大概率会丢失掉，需要重新计算

【原则上】尽可能只用一个脚本更新一个表的数据，必须用两个脚本时，添加 更新表的 created_at > TODAY_START 作为条件，新增的数据都要更新
```

```sql
REPLACE INTO table_name (column_name1, column_name2)
  SELECT column1, column2 
  FROM table1 
  LEFT JOIN table2 ON condition 
  WHERE condition 
  GROUP BY union_unique_key
```

* 更新数据
> 考虑并发问题，更新数据时指定条件要带上当前支持操作的条件。如：状态变更
```sql
-- 避免单一修改与批量修改同时操作导致数据不一致问题，单个修改时加锁，批量修改时加状态条件
UPDATE table_name
SET status = new_status
WHERE status = can_handle_status AND uniq_code = 唯一编码
```

* 清理数据

> 如果是清空表数据建议直接用 truncate

```tip
效率上 truncate 远高于 delete，应为 truncate 不走事务，不会锁表，也不会生产大量日志写入日志文件；
truncate table table_name 后立刻释放磁盘空间，并重置 auto_increment 的值。

delete 删除不释放磁盘空间，但后续 insert 会覆盖在之前删除的数据上。
```

## SQL高级用法

* SQL_CALC_FOUND_ROWS

```tip
获取列表数据 + 获取列表总数量，常规用法需要两条SQL语句；通过一条SQL也可以办到
```

```sql
-- 低配版本
SELECT * FROM student WHERE id < 1000 LIMIT 10,10 ;
SELECT count(id) FROM student WHERE id < 1000 ;

-- 高配版本
SELECT SQL_CALC_FOUND_ROWS *
FROM student
WHERE id < 1000
LIMIT 10, 10;

SELECT FOUND_ROWS() AS total_count;
```

```php
//  laravel用法
$list = $this->model->select([DB::raw("SQL_CALC_FOUND_ROWS [*|字段列表]")])
    ->offset($offet)
    ->limit($limit)
    ->groupBy('column1','column2')
    ->get();

$total = DB::select(DB::raw('SELECT FOUND_ROWS() as total'))[0]->total;
```

## WITH 

```tip
mysql版本在8.0之前不能使用with的写法
```

* 编写复杂SQL语句要养成使用 WITH 语句的习惯

```sql
SELECT    a.*,
          c.allocated
FROM      (
                   SELECT   resourceid
                   FROM     my_distribute d
                   WHERE    isdelete = 0
                   AND      cusmanagercode = '1234567'
                   ORDER BY salecode limit 20) a
LEFT JOIN
          (
                   SELECT   resourcesid， sum(ifnull(allocation, 0) * 12345) allocated
                   FROM     my_resources r,
                            (
                                     SELECT   resourceid
                                     FROM     my_distribute d
                                     WHERE    isdelete = 0
                                     AND      cusmanagercode = '1234567'
                                     ORDER BY salecode limit 20) a
                   WHERE    r.resourcesid = a.resourcesid
                   GROUP BY resourcesid) c
ON        a.resourceid = c.resourcesid
```
子查询 a 在我们的SQL语句中出现了多次。这种写法不仅存在额外的开销，还使得整个语句显的繁杂。使用 WITH 语句再次重写：
```sql
WITH a AS
(
         SELECT   resourceid
         FROM     my_distribute d
         WHERE    isdelete = 0
         AND      cusmanagercode = '1234567'
         ORDER BY salecode 
         LIMIT 20
)
SELECT    a.*,
          c.allocated
FROM      a
LEFT JOIN(
         SELECT   resourcesid, sum(ifnull(allocation, 0) * 12345) allocated
         FROM     my_resources r,  a
         WHERE    r.resourcesid = a.resourcesid
         GROUP BY resourcesid
    ) c ON        a.resourceid = c.resourcesid
```

## 刷数而不影响updated_at字段的值
> 避免影响数据排序
```mysql
UPDATE table_name
SET column_key = 'value',
    updated_at = CASE
       WHEN 0 THEN	NOW()
       ELSE updated_at
    END
WHERE condition_column = 'condition'
```


## 刷数更新SET类型数据
> 避免影响数据排序
```mysql
UPDATE TABLE_NAME
SET COLUMN = TRIM(BOTH ',' FROM REPLACE(CONCAT(',', COLUMN, ','), ',3,', ',3,8,'))
WHERE FIND_IN_SET('3', COLUMN) > 0;
```

## Danger

```danger
delete、update 要命中索引，强烈推荐使用limit参数限制影响数量，避免锁表(多个事务并行时，即使每条影响数量不多也可能锁表)

统计类数据的 delete 锁表问题可通过 增加版本号来解决，每次刷新数据使用新的版本号，定期清理过期的统计数据，避免更新时删除数据 
```
