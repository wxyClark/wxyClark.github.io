# ElasticSearch

[官方文档](https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started.html)

[官方 中文](https://www.elastic.co/cn/elasticsearch/)

[阮一峰 全文搜索引擎 Elasticsearch 入门教程](http://www.ruanyifeng.com/blog/2017/08/elasticsearch.html)

[Elasticsearch权威指南中文版(书栈网)](https://www.bookstack.cn/read/elasticsearch-definitive-guide-cn/)

- Elasticsearch 是一个分布式、开源的、RESTful 风格的搜索和数据分析引擎。
- 支持各种数据类型，包括文本、数字、地理、结构化、非结构化。
- Elastic Search基于lucene， Lucene是apache下的一个开源的，一套用java写的全文检索的工具包。
- Lucene 中对文档检索基于【**倒排索引**】实现，并将它发挥到了极致。

ES集群对外提供RESTful API

| 版本          | 差异          | date |
| ------ | --------| ----- |
| Elastic 5.x | Lucene 6.x 的支持，磁盘空间少一半；索引时间少一半；查询性能提升25%；支持IPV6       | 2016.10.26 |
| Elastic 6.x | 开始不支持一个 index 里面存在多个 type。  | 2017.08.31 |
| Elastic 7.x | 正式废除单个索引下多Type的支持，7.1开始，Security功能免费使用，支持k8s | 2019.04.10 |


```tip
【默认所有字段建索引】不需要索引的字段，一定要明确定义出来

【string类型默认分词】对于String类型的字段，不需要analysis（分词）的也需要明确定义出来

【选择有规律的ID很重要】随机性太大的ID（比如UUID）不利于查询

充分利用倒排索引机制，能 keyword 类型尽量 keyword

数据量大时候，可以先基于时间敲定索引再检索 index_name_[date], 冷热数据分离

禁用批量 terms（成百上千的场景）

慎用 wildcard

【倒排索引】，是通过分词策略，形成了词和文章的映射关系表，这种【词典 + 映射】表即为倒排索引。

有了倒排索引，就能实现 o（1）时间复杂度的效率检索文章了，极大的提高了检索效率(空间占用小、查询速度快)。
```

## ELK

E: ElasticSearch

```tip
注意MySQL ES 时区配置是否一致

mysql datetime 数据写入ES 会变成longInt类型 读取时手动格式化 
```

```php
$dateTime = '-';
if (isset($item['esDateTime']) && $item['esDateTime'] > 1000) {
    $dateTime = date('Y-m-d H:i:s', $item['esDateTime']);
}
```

## ES适合什么场景
ES 适合做查询， mongoDB适合做CURD
### MySQL不适合做查询的场景
- 存储问题：数据量大(如：上亿)需要分库分表
- 性能问题：模糊查询用不到索引，效率低
- 分词问题：匹配模式单一


## 安装
### 前置条件
Elastic 需要 Java 8 环境。注意要保证环境变量JAVA_HOME正确设置。

### 安装配置

```cs
$ wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.1.zip
$ unzip elasticsearch-5.5.1.zip
$ cd elasticsearch-5.5.1/ 
 ./bin/elasticsearch
```

* Elastic 就会在默认的9200端口运行
```cs
curl localhost:9200
```

* 设置远程访问

  Elastic 默认只允许本机访问

  修改 Elastic 安装目录的config/elasticsearch.yml文件

  将它的值改成0.0.0.0（任何人都可以访问，线上不建议），然后重新启动 Elastic。
  
  去掉network.host的注释

```cs
network.host: 0.0.0.0
```
### 后置条件
ELK分别表示：Elasticsearch , Logstash， Kibana , 它们都是开源软件。

## 基本概念

Elastic 本质上是一个分布式数据库，允许多台服务器协同工作， 每台服务器可以运行多个 Elastic 实例。

| 概念    | 定义  | 类比MySQL |
| ------- | -------- | -------- |
| 全文检索 | 从非结构化数据(文档)中提取出的然后重新组织（分词）的信息，我们称之索引。先建立索引，再对索引进行搜索的过程就叫全文检索。 |  |
| 倒排索引 | 实现“单词-文档矩阵”的一种具体存储形式，可以根据单词快速获取包含这个单词的文档列表。 |字典|
| 集群(cluster)| 一组节点构成一个集群(cluster) |集群|
| 节点(node)| 一个 Elastic 实例称为一个节点(node) |服务器|
| 索引(index)| Elastic 会索引所有字段，经过处理后写入一个 反向索引(Inverted Index)， 用于查询。|数据库(Database)|
| 分组(type)|虚拟的逻辑分组，用来过滤文档(document)，不同的 分组(type) 应该有相似的 结构(scheme)|表(table)|
| 文档(document)|  索引(index)里面单条的记录称为 文档(document)|数据行(row)|
| 映射(mapping)| 定义索引中的字段的名称、数据类型|约束(schema)|


### 索引 index
* Elastic 数据管理的顶层单位就叫做 Index（索引）。
* 它是单个数据库的同义词。每个 Index （即数据库）的名字必须是小写。
* 同一个 Index 里面的 Document，不要求有相同的结构(scheme)，但是最好保持相同，这样有利于提高搜索效率。

## 数据类型
| 分类  | 数据类型 |
| --- | --- | 
| 字符串 | Thriller   text（分词） keyword（不分词）   | 
| 数值型 | long integer short byte double float half_flot scaled_float| 
| 布尔   | boolean |
| 日期   | date |
| 二进制 | binary |
| 范围类型 | integer_range,float_range,long_range,double_range,date_range |

## 操作

| 操作项          | 命令          | 说明 |
| --------------- | -------------- | ---- |
| 新建 Index | curl -X PUT 'localhost:9200/weather'       | 索引名称weather |
| 查看所有 Index          |curl -X GET 'localhost:9200/_cat/indices?v'    | 1984 |
| 列出每个Index所包含的Type | curl 'localhost:9200/_mapping?pretty=true' | 1986 |
| 删除 Index    | curl -X DELETE 'localhost:9200/weather' | 1986 |
| 查询所有  | curl 'localhost:9200/accounts/person/_search' | AND 须使用布尔查询 |
| 查询记录  | curl 'localhost:9200/accounts/person/1?pretty=true' | 以易读的格式返回 |


### 新建 Index
直接向 Elastic 服务器发出 PUT 请求。下面的例子是新建一个名叫weather的 Index
> curl -X PUT 'localhost:9200/weather'

服务器返回一个 JSON 对象，里面的acknowledged字段表示操作成功。


向指定的 /Index/Type 发送 PUT 请求，就可以在 Index 里面新增一条记录

注：accounts/person/1 的1 是该条记录的 Id。它不一定是数字，任意字符串（比如abc）都可以
>  curl -X PUT 'localhost:9200/accounts/person/1 -d'
```json
{
  "user": "张三",
  "title": "工程师",
  "desc": "数据库管理"
}
```
也可以不指定ID，使用POST新增记录
> curl -X POST 'localhost:9200/accounts/person -d'
```json
{
  "user": "李四",
  "title": "工程师",
  "desc": "系统管理"
}
```
```tip
注意，如果没有先创建 Index，直接执行新增记录的命令，Elastic 也不会报错，而是直接生成指定的 Index。
所以，打字的时候要小心，不要写错 Index 的名称。
```

### 查看 Index

查看当前节点的所有 Index
> curl -X GET 'http://localhost:9200/_cat/indices?v'

列出每个 Index 所包含的 Type
> curl 'localhost:9200/_mapping?pretty=true'

### 删除 Index

发出 DELETE 请求，删除一个 Index
> curl -X DELETE 'localhost:9200/weather'

### 查看记录
发送GET请求。 pretty=true表示以易读的格式返回。如果 Id 不正确，就查不到数据，found字段就是false。
> curl 'localhost:9200/accounts/person/1?pretty=true'

### 更新记录
使用 PUT 请求，重新发送一次数据。
> curl -X PUT 'localhost:9200/accounts/person/1 -d '
```json
{
    "user" : "张三",
    "title" : "工程师",
    "desc" : "数据库管理，软件开发"
}
```

### 删除记录
发送DELETE请求
> curl -X DELETE 'localhost:9200/accounts/person/1


## 数据查询

[CSDN博主21_Days的原创文章](https://blog.csdn.net/qq1592/article/details/119081067)

### query基本匹配查询关键字说明

| 关键字          | 说明         | 
| --- | --- | 
| match_all  | 查询简单的 匹配所有文档。在没有指定查询方式时，它是默认的查询       | 
| match | 用于全文搜索或者精确查询，如果在一个精确值的字段上使用它， 例如数字、日期、布尔或者一个 not_analyzed 字符串字段，那么它将会精确匹配给定的值    | 
| range | 查询找出那些落在指定区间内的数字或者时间<br> gt 大于 <br> gte 大于等于 <br> lt 小于 <br> lte 小于等于 | 
| term     | 被用于精确值 匹配 | 
| terms     | terms 查询和 term 查询一样，但它允许你指定多值进行匹配 | 
| exists     | 查找那些指定字段中有值的文档 | 
| missing     | 查找那些指定字段中无值的文档 | 
| must     | 多组合查询 必须匹配这些条件才能被包含进来 | 
| must_not     | 多组合查询 必须不匹配这些条件才能被包含进来 | 
| should     | 多组合查询 如果满足这些语句中的任意语句，将增加 _score ，否则，无任何影响。它们主要用于修正每个文档的相关性得分 | 
| filter     | 多组合查询 这些语句对评分没有贡献，只是根据过滤标准来排除或包含文档 | 

### 返回结果字段解释	

| 字段          | 说明  | 备注 |
| ------ | ---- | ---- |
| took | 耗费了几毫秒       |  |
| timed_out          | 是否超时    | true、false |
| _shards    | 数据拆成5个分片，对于搜索请求，会打到所有的primary shard（或者是它的某个replica shard也可以），所以total和successful会是5； |  |
| hits    | 查询的所有结果 | 统计数据 |
| hits.total    | 查询结果的数量（多少个 document） |  |
| hits.max_score    | score的含义就是document对于一个search的相关度的匹配分数 | 越相关、就越匹配，分数也越高 |
| hits.hits    | 匹配搜索的document的详细数据 |  |
| hits._index    | 该文档所属的index |  |
| hits._type    | 该文档所属的type |  |
| hits._id    | 该文档的id|  |
| hits._source    | 具体的内容，即存储的json串| document内容 |

### 返回所有记录
使用 GET 方法，直接请求/Index/Type/_search，就会返回所有记录。

返回结果的 took字段表示该操作的耗时（单位为毫秒），timed_out字段表示是否超时;max_score：最高的匹配程度。
> curl 'localhost:9200/accounts/person/_search'

### 全文搜索
Elastic 的查询非常特别，使用自己的查询语法，要求 GET 请求带有数据体。size 默认10 类似limit,from类似offset指定位移
> curl 'localhost:9200/accounts/person/_search  -d '
```json
{
    "query" : { "match" : { "desc" : "软件" }},
    "from": 20,
    "size": 20,
}
```

### 逻辑运算
如果有多个搜索关键字， Elastic 认为它们是or关系。例： 软件 or 系统
> curl 'localhost:9200/accounts/person/_search  -d '
```json
{
    "query" : { "match" : { "desc" : "软件 系统" }}
}
```
如果要执行多个关键词的and搜索，必须使用布尔查询。
> curl 'localhost:9200/accounts/person/_search  -d '
```json
{
  "query": {
    "bool": {
      "must": [
        { "match": { "desc": "软件" } },
        { "match": { "desc": "系统" } }
      ]
    }
  }
}
```

## 中文分词设置
### 安装中文分词插件