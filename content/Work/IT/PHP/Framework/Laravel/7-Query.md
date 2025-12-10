---
sort: 7
---

# 查询

**【定义$query 至少应调用一个函数：】**
```danger
$query = $this->model; 会导致后面的 $query->条件时效
$query = $this->model->select($fields);
$query = $this->model->newQuery();
```

```tip
单表查询 单挑结果转数组：
$result = $query->first();
return $result ? $result->toArray(): [];

联表查询 结果集转数组：return json_decode(json_encode($result), true);

打印SQL：
$sql = str_replace('?', '%s', $query->toSql());
$sql = sprintf($sql, ...$query->getBindings());
dd($sql);

```
[快捷打印 Laravel 中的数据库查询（SQL）语句](https://learnku.com/articles/5166/quick-print-laravel-database-query-sql-statement)


## 打印整个function中的所有SQL：
```php
function yourFunction() {
    DB::enableQueryLog(); // 开启日志记录

    // 你的业务逻辑（如：User::where('status', 1)->get()）
    // 如果存在遍历，设置条件让遍历只走一次
    
    $queries = DB::getQueryLog(); // 获取日志
    foreach ($queries as &$query_sql) {
        $query_sql['full_sql'] = vsprintf(str_replace('?', "'%s'", $query_sql['query']), $query_sql['bindings']);
        unset($query_sql['bindings'], $query_sql['query'], $query_sql['time']);
    }
    dd($queries); // 打印所有SQL及绑定参数
}
```

## collect()

同一组数据需要按不同维度聚合，可以一次查询，对结果集再做分组计算

## pluck

支持获取 key => value 数组，也可以只获取 value 数组

```php
$map = $this->model->where($condition)->distinct()->pluck('value'[, 'key']);
//  toArray前判空

return $map ? $map->toArray() : [];
```

二维数组使用pluck

```php
$collection = collect([
    ['product_id' => 'prod-100', 'name' => 'Desk', 'price'=>10.2],
    ['product_id' => 'prod-200', 'name' => 'Chair', 'price'=>10.3],
]);
return $collection->pluck('name', 'product_id');
```

## count

按指定字段唯一值统计数量
```php
    public function getAccountTotalCount($params)
    {
        return $this->baseQuery($params)->count(DB::raw("distinct(account_code)"));
    }
```

## 原生SQL

```php
【*】这是错误的用法
$query->where(DB::raw("(is_reply = 2 OR (is_reply = 1 AND reply_at > '". '2022-5-14 00:00:00' ."'))"));
$query->whereRaw("(is_reply = 2 OR (is_reply = 1 AND reply_at > '". '2022-5-14 00:00:00' ."'))");
```

## batch

```danger
尤其导入数据，支持部分列为空不更新时
```
* batchInsert 插入数据，【强烈建议】统一数组的长度（每个数据拥有的key是一致的，避免数据错位）。

```sql
-- 如：部分列没有 freight
insert into `oms_order_shipping_fee`
    (`country_code`, `freight`, `logistics_channel_code`, `logistics_no`, `occurrence_time`) 
values
    (CA, 1.23, CA, YH2081746307SZ, 1970-01-01 08:00:01),
    (CA, CA, YH2081746312SZ, 1970-01-01 08:00:01),
    (CA, CA,YH2081746308SZ, 1970-01-01 08:00:01),
    (CA, CA, YH2081746306SZ, 1970-01-01 08:00:01),
    (CA, CA, YH2081746315SZ, 1970-01-01 08:00:01),
    (CA, CA, YH2081746303SZ, 1970-01-01 08:00:01),
    (CA, CA, YH2081746304SZ, 1970-01-01 08:00:01),
    (CA, CA, YH2081746309SZ, 1970-01-01 08:00:01),
    (CA, CA, YH2081746313SZ, 1970-01-01 08:00:01),
    (CA, CA, YH2081746314SZ, 1970-01-01 08:00:01),
    (CA, CA, YH2081746311SZ, 1970-01-01 08:00:01),
    (CA, CA, YH2081746305SZ, 1970-01-01 08:00:01)
)
```
