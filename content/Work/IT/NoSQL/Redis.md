# Redis
适用场景

## 数据类型

| 数据类型          | 数据结构          | 适用场景 |
| --------------- | -------------- | ---- |
| string |        |  |
| list          |      |  |
| hash          |      |  |
| set    |  |  |
| zset    |  |  |

## 原子操作

## 分布式锁

## 数据一致性

## 技术方案

## 实战

### 队列消费

* 数组批量读写
* 必要字段
```tip
[
    'tenant_id' => '*租户ID,数据按租户隔离',
    'biz_uniq_code' => '*业务相关唯一编码',
    'biz_data' => '业务数据',
    'biz_tag' => '业务标记，时间、类型等',
    'retry_times' => '*重试次数',
]
```

* 登录 redis-cli -h host_ip -p port -a password
