---
sort: 4
---

# 搜索

```tip
Es 模糊查询， 分词的用match； 

短语的用match_phrase；

查询任意的，用wildcard通配符，注意查询的内容是否分词，分词的添加keyword，查询非空的情况，用*。

Wildcard 性能会比较慢。如果非必要，尽量避免在开头加通配符 ? 或者 *，这样会明显降低查询性能
```

```json
{
    "wildcard": {
        "form_name.keyword": "*very*"
    }
}
```

> 如果查询的内容非空，怎么处理？ 直接用*
```json
{
    "wildcard": {
        "form_name": "*"
    }
}
```

## 结构化查询 Query DSL

* 空查询
> GET /_search
```json
{
    "query": {
        "match_all": {}
    }
}
```
* 查询子句
> 一个查询子句一般使用这种结构：
```json
{
    QUERY_NAME: {
        FIELD_NAME: {
            ARGUMENT: VALUE,
            ARGUMENT: VALUE,...
        }
    }
}
```

> 举例 GET /_search
```json
{
    "query": {
        "match": {
            "tweet": "elasticsearch"
        }
    }
}
```

* 合并多子句
> 叶子子句(leaf clauses)(比如match子句)用以在将查询字符串与一个字段(或多字段)进行比较

> 复合子句(compound)用以合并其他的子句,bool: must, must_not, should

> 复合子句可以相互嵌套
```json
{
    "bool": {
        "must": { "match":      { "email": "business opportunity" }},
        "should": [
            { "match":         { "starred": true }},
            { 
                "bool": {
                    "must":      { "folder": "inbox" },
                    "must_not":  { "spam": true }
                }
            }
        ],
        "minimum_should_match": 1
    }
}
```

## 想知道语句非法的具体错误信息，需要加上 explain 参数
> GET /index_name/type_name/query?explain
```json
{
   "query": {
      "tweet" : {
         "match" : "really powerful"
      }
   }
}
```

> 语句错误的详情 "error"

> 语句正确的解释 "explanation"

## 最重要的查询过滤语句 filter & query

* 询语句可以包含过滤子句，反之亦然
* 复合查询语句可以加入其他查询子句，复合过滤语句也可以加入其他过滤子句。
> GET /_search
```json
{
    "query": {
        "filtered": {
            "filter":   {
                "bool": {
                    "must":     { "term":  { "folder": "inbox" }},
                        "must_not": {
                            "query": {
                            "match": { "email": "urgent business proposal" }
                        }
                    }
                }
            }
        }
    }
}
```

| 关键词 | 用途 | 举例 |
| ---- | ---- | ---- |
| term过滤 | **精确匹配** | 比如数字，日期，布尔值<br>或 not_analyzed的字符串(未经分析的文本数据类型) |
| terms过滤 | **精确匹配** <br>允许指定多个匹配条件 | 同上 | 
|  |  |  |
| range过滤 | 按照指定范围**过滤** |范围操作符包含：<br> gt 大于 <br> gte 大于等于 <br> lt 小于等于 <br> lte 小于等于|
|  |  |  | 
| exists过滤 | 包含指定字段 | 只是针对已经查出一批数据来，但是想区分出某个字段是否存在的时候使用 | 
| missing过滤 | **不**包含指定字段 | 同上 |
|  |  |  |
| bool过滤 | 用来合并多个过滤条件 | 操作符：<br> must: 多个查询条件的完全匹配,相当于 and <br> must_not: 多个查询条件的相反匹配，相当于 not <br> should: 至少有一个查询条件匹配, 相当于 or | 
|  |  |  |
| bool 查询| 合并多个查询子句 | 操作符：<br> must: 查询指定文档一定要被包含 <br> must_not: 查询指定文档一定不要被包含 <br> should: 查询指定文档，有则可以为文档相关性加分 |
|  |  |  |
| match_all查询 | 查询到所有文档 | 是没有查询条件下的默认语句 | 
| match查询 | 查询是一个标准查询 | 不管你需要全文本查询还是精确查询基本上都要用到它 |
| multi_match查询 | 查询允许你做match查询的基础上同时搜索多个字段 | C |


```json
{
  
    "term": { 
      "age":26
    },

    "terms": {
        "tag": [ "search", "full_text", "nosql" ]
    },

    "range": {
        "age": {
              "gte":  20,
              "lt":   30
        }
    },

    "exists":   {
        "field":    "title"
    }

    "bool": {
        "must":     { "term": { "folder": "inbox" }},
        "must_not": { "term": { "tag":    "spam"  }},
        "should": [
                    { "term": { "starred": true   }},
                    { "term": { "unread":  true   }}
        ]
    },

    "match": {
      "tweet": "About Search"
    },
    
    "multi_match": {
        "query":    "full text search",
        "fields":   [ "title", "body" ]
    }
}
```

> 以下查询将会找到 title 字段中包含 “how to make millions”，并且 “tag” 字段没有被标为 spam。
如果有标识为 “starred” 或者发布日期为2014年之前，那么这些匹配的文档将比同类网站等级高：
```json
{
  "bool": {
    "must":     { "match": { "title": "how to make millions" }},
    "must_not": { "match": { "tag":   "spam" }},
    "should": [
      { "match": { "tag": "starred" }},
      { "range": { "date": { "gte": "2014-01-01" }}}
    ]
  }
}
```

## 排序 sort

* 过滤语句与 _score 没有关系，但是有隐含的查询条件 match_all 为所有的文档的 _score 设值为 1
* 使用 sort 参数进行排序
```json
{
    "query" : {
        "filtered" : {
            "filter" : { "term" : { "user_id" : 1 }}
        }
    },
    "sort": { "date": { "order": "desc" }}
}
```
* 计算 _score 是比较消耗性能的,
* 如果你想强制计算其相关性，可以设置track_scores为 true。
* 字段值默认以顺序排列，而 _score 默认以倒序排列。

### 多级排序

> 如果我们想要合并一个查询语句，并且展示所有匹配的结果集使用第一排序是date，第二排序是 _score：
```json
{
    "query" : {
        "filtered" : {
            "query":   { "match": { "tweet": "manage text search" }},
            "filter" : { "term" : { "user_id" : 2 }}
        }
    },
    "sort": [
        { "date":   { "order": "desc" }},
        { "_score": { "order": "desc" }}
    ]
}
```

* 为多值字段排序
> 对于数字和日期，你可以从多个值中取出一个来进行排序，你可以使用min, max, avg 或 sum这些模式。

> 比说你可以在 dates 字段中用最早的日期来进行排序：
```json
{
    "sort": {
        "dates": {
            "order": "asc",
            "mode":  "min"
        }
    }
}
```

* 为了使一个string字段可以进行排序，它必须只包含一个词：即完整的not_analyzed字符串(译者注：未经分析器分词并排序的原字符串)。
* 在 _source 下相同的字符串上排序两次会造成不必要的资源浪费。

### 同一个字段中同时包含这两种索引方式

```danger
对 analyzed 字段进行强制排序会消耗大量内存。
```

```json
{
    "tweet": {
        "type": "string",
        "analyzer": "english"
    }
}
```
* 我们只需要改变索引(index)的mapping即可,新增的 tweet.raw 子字段索引方式是 not_analyzed
```json
{
    "tweet": {
        "type": "string",
        "analyzer": "english",
        "fields": {
            "raw": {
                "type":  "string",
                "index": "not_analyzed"
            }
        }
    }
}
```

> GET /_search
```json
{
    "query": {
        "match": {
            "tweet": "elasticsearch"
        }
    },
    "sort": "tweet.raw"
}
```

### 相关性

* 每个文档都有相关性评分，用一个相对的浮点数字段 _score 来表示， _score 的评分越高，相关性越高。
* 检索词频率:检索词在该字段出现的频率？出现频率越高，相关性也越高。
* 反向文档频率:每个检索词在索引中出现的频率？频率越高，相关性越低。
* 字段长度准则:字段的长度是多少？长度越长，相关性越低。
* 增加一个 explain 参数会为每个匹配到的文档产生一大堆额外内容，包括评分 _score
> 返回值中的 _explanation 会包含在每一个入口，告诉你采用了哪种计算方式，并让你知道计算的结果以及其他详情:

```json
{
   "query"   : { "match" : { "tweet" : "honeymoon" }}
}
```

```tip
JSON形式的explain描述是难以阅读的

但是转成 YAML 会好很多，只需要在参数中加上 format=yaml
```

```json
{
    "_explanation": {
        //  honeymoon 相关性评分计算的总结 
        "description": "weight(tweet:honeymoon in 0)[PerFieldSimilarity, result of:",
        "value": 0.076713204,
        "details": [
            {
                "description": "fieldWeight in 0, product of:",
                "value": 0.076713204,
                "details": [
                
                    //   检索词频率
                    {  
                        "description": "tf(freq=1.0), with freq of:",
                        "value": 1,
                        "details": [
                            {
                                "description": "termFreq=1.0",
                                "value": 1
                            }
                        ]
                    },
                    
                    //    反向文档频率
                    { 
                        "description": "idf(docFreq=1, maxDocs=1)",
                        "value": 0.30685282
                    },
                    
                    //    字段长度准则
                    { 
                        "description": "fieldNorm(doc=0)",
                        "value": 0.25,
                    }
                ]
          }
        ]
    }
}
```

## ElasticSearch中的字段数据常被应用到以下场景

* 对一个字段进行排序
* 对一个字段进行聚合
* 某些过滤，比如地理位置过滤
* 某些与字段相关的脚本计算