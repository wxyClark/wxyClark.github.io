---
sort: 3
---

# 数据

* 在Elasticsearch中，每一个字段的数据都是默认被索引的。——每个字段专门有一个反向索引用于快速检索。
  在Elasticsearch中，文档(document)特指最顶层结构或者根对象(root object)序列化成的JSON数据（以唯一ID标识并存储于Elasticsearch中）
  > 文档元数据(metadata)

| 节点 | 说明 | 备注 |
| ---- | ---- | ---- | 
| _index | 文档存储的地方 | 必须是全部小写，不能以下划线开头，不能包含逗号 |
| _type | 文档代表的对象的类 | 名字可以是大写或小写，不能包含下划线或逗号 |
| _id | 文档的唯一标识 | 仅是一个字符串 <br> 当创建一个文档，你可以自定义_id，也可以让Elasticsearch帮你自动生成 |

* 文档是不可变的——它们不能被更改，只能被替换。

## 版本控制

* API更新文档的时候，最近的索引请求会生效——Elasticsearch中只存储最后被索引的任何文档。
* 如果其他人同时也修改了这个文档，他们的修改将会丢失。
* ①悲观并发控制（Pessimistic concurrency control）
> 读一行数据前锁定这行，然后确保只有加锁的那个线程可以修改这行数据
* ②乐观并发控制（Optimistic concurrency control）
> 比对版本号 _version ，如果版本号一致，则修改这行数据，_version++; 如果版本号不一致，则抛出异常

> lasticsearch即是同步的又是异步的，意思是这些复制请求都是平行发送的，并无序(out of sequence)的到达目的地。

> 这就需要一种方法确保老版本的文档永远不会覆盖新的版本。

* ③使用外部版本控制系统
> 一种常见的结构是使用一些其他的数据库做为主数据库，然后使用Elasticsearch搜索数据，这意味着所有主数据库发生变化，就要将其拷贝到Elasticsearch中。

> 如果有多个进程负责这些数据的同步，就会遇到上面提到的并发问题。

* 局部更新，对于多用户的局部更新，如果冲突发生，我们唯一要做的仅仅是重新尝试更新既可

## 检索多个文档

* 合并多个请求可以避免每个请求单独的网络开销。
* 在一个请求中使用multi-get或者mget API。
> POST /index_name/type_name/_mget
* 通过简单的ids数组,简化查询条件
> POST /website/blog/_mget
```json
{
   "ids" : [ "2", "1" ]
}
```

* 事实上第二个文档不存在并不影响第一个文档的检索。每个文档的检索和报告都是独立的。
```json
{
  "docs" : [
    {
      "_index" :   "website",
      "_type" :    "blog",
      "_id" :      "2",
      "_version" : 10,
      "found" :    true,
      "_source" : {
        "title":   "My first external blog entry",
        "text":    "This is a piece of cake..."
      }
    },
    {
      "_index" :   "website",
      "_type" :    "blog",
      "_id" :      "1",
      "found" :    false 
    }
  ]
}
```

## 更新时的批量操作

* bulk API允许我们使用单一请求来实现多个文档的create、index、update或delete。
> 必须指定文档的_index、_type、_id这些元数据(metadata)

> 每行必须以"\n"符号结尾，包括最后一行。这些都是作为每行有效的分离而做的标记。

> 每一行的数据不能包含未被转义的换行符，它们会干扰分析——这意味着JSON不能被美化打印。
```json
{ action: { metadata }}\n
{ request body        }\n
{ action: { metadata }}\n
{ request body        }\n
```
* 行为(action)必须是以下几种：

| 行为 | 解释 | 备注 |
| ---- | ---- | ---- |
| create | 当文档不存在时创建之。 | 必须指元数据(metadata) |
| index | 创建新文档或替换已有文档。 | 必须指元数据(metadata) |
| update | 局部更新文档。 | 必须指元数据(metadata) 
| delete | 删除一个文档。 | 没有请求体 |

* bulk请求不是原子操作——它们不能实现事务。每个请求操作时是分开的，所以每个请求的成功与否不干扰其它操作。
* 整个批量请求需要被加载到接受我们请求节点的内存里，所以请求越大，给其它请求可用的内存就越小。
* 一个好的批次最好保持在5-15MB大小间。

## 存储

* 新文档存储在哪个分片上？
> 进程不能是随机的，因为我们将来要检索文档。它根据一个简单的算法决定：
```shell
shard = hash(routing) % number_of_primary_shards
# routing值是一个任意字符串，它默认是_id但也可以自定义。
# 余数(remainder)的范围永远是0到number_of_primary_shards - 1
# 如果主分片的数量在未来改变了，所有先前的路由值就失效了，文档也就永远找不到了。
```