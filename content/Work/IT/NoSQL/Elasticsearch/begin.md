---
sort: 1
---

# 入门


| 简写 | 全称 | 释意 | 备注 |
| --- | --- | --- | --- |
| JSON | JavaScript Object Notation | Javascript对象符号 | --- |
| DSL | Domain Specific Language | 特定领域语言 | --- |



* 天生支持分布式(大量非关键数据的存储首先考虑ES)
* Elasticsearch是一个基于Apache Lucene(TM)的开源搜索引擎。无论在开源还是专有领域，Lucene可以被认为是迄今为止最先进、性能最好的、功能最全的搜索引擎库。
* ELasticsearch使用 **JSON** 作为文档序列化格式
* 在Elasticsearch中存储数据的行为就叫做**索引(indexing)**
  > Relational DB -> Databases -> Tables -> Rows -> Columns   | 索引(index)
  
  > Elasticsearch -> 索引Indices   -> Types  -> Documents -> Fields  | 倒排索引(inverted index)
* 默认情况下，文档中的所有字段都会被索引（拥有一个倒排索引），只有这样他们才是可被搜索的。
* 建立或更新索引    ：PUT /index_name/type_name/ID JSON
* 检查文档是否存在 ：HEAD /index_name/type_name/ID
* 删除文档      ：DELETE /index_name/type_name/ID
* 检索文档         ：GET /index_name/type_name/ID 返回的JSON文档在 _source 字段中
* 搜索全部         ：GET /index_name/type_name/_search
* query查询       ：GET /index_name/type_name/_search?**q=last_name:Smith**
* DSL语句查询      ：GET /index_name/type_name/_search **JSON**
> GET /index_name/type_name/_search
```json
{
    "query" : {
        "match" : {
            "last_name" : "Smith"
        }
    }
}
```  
* 匹配类型：match、过滤器filter、短语查询match_phrase、高亮highlight
* 聚合(aggregations)aggs 类似于SQL的GROUP BY
* 美化：在任意的查询字符串中增加pretty参数,除 _source 外，其他字段都会被美化
> GET /index_name/type_name/_search?pretty
```json
{
  "_index" :   "website",
  "_type" :    "blog",
  "_id" :      "123",
  "_version" : 1,
  "found" :    true,  //  数据是否存在
  "_source" :  {
    "title": "My first blog entry",
    "text":  "Just trying this out...",
    "date":  "2014/01/01"
  }
}
```
* 指定查询字段 _source , 返回值的 _source 只返回指定的字段 
> GET /index_name/type_name/_search?source=title,text
* 只想得到 _source 字段而不要其他的元数据
> GET /index_name/type_name/_source
* _all 查询
> GET /index_name/type_name/_search?q=搜素关键词
* 是否超时——Elasticsearch将返回在请求超时前收集到的结果。
> GET /_search?timeout=10ms
```danger
需要注意的是timeout不会停止执行查询，它仅仅告诉你目前顺利返回结果的节点然后关闭连接。

在后台，其他分片可能依旧执行查询，尽管结果已经被发送。
```
* 分页， from(跳过数)、 size(结果数) <= 1000
```danger
应该当心分页太深或者一次请求太多的结果。结果在返回前会被排序。

但是记住一个搜索请求常常涉及多个分片。

每个分片生成自己排好序的结果，它们接着需要集中起来排序以确保整体排序正确。
```

## 测试分析器

尤其当你是Elasticsearch新手时，对于如何分词以及存储到索引中理解起来比较困难。

为了更好的理解如何进行，你可以使用analyze API来查看文本是如何被分析的。

> GET /_analyze?analyzer=standard&text=Text to analyze