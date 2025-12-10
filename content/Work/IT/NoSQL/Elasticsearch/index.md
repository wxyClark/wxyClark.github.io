---
sort: 5
---

# 索引

## 创建索引

> PUT /index_name

```json
{
    "settings": {
        //  主分片个数，默认值是 `5`。这个配置在索引创建后不能修改
        "number_of_shards": 5,
      
        //  复制分片个数，默认是 `1`。这个配置可以随时在活跃的索引上修改
        "number_of_replicas": 1,
      
        //  配置分析器
        "analysis": {
            "analyzer": {
                //  es_std 分析器不是全局的，它仅仅存在于我们定义的 spanish_docs 索引中
                "es_std": {
                    //  standard 分词器，在词层级上分割输入的文本
                    //  lowercase 标记过滤器，将所有标记转换为小写
                    //  stop 标记过滤器，删除所有可能会造成搜索歧义的停用词(如 a，the，and，is);
                    //    默认情况下，停用词过滤器是被禁用的。
                    //    如需启用它，你可以通过创建一个基于 standard 分析器的自定义分析器，并且设置 stopwords 参数。
                    "type":      "standard",
                    "stopwords": "_spanish_"
                },
              
                //  分析器 是三个顺序执行的组件的结合（字符过滤器，分词器，标记过滤器）
              
                //  ①【字符过滤器】是让字符串在被分词前变得更加“整洁”。
                "char_filter": {
                    "&_to_and": {
                        "type":       "mapping",
                        "mappings": [ "&=> and "]
                    }
                },
                "filter": {
                    "my_stopwords": {
                        "type":       "stop",
                        "stopwords": [ "the", "a" ]
                    }
                },
                "tokenizer":   { ...    custom tokenizers     ... },
                "analyzer": {
                    "my_analyzer": {
                        
                        "type":         "custom",
                        "char_filter":  [ "html_strip", "&_to_and" ],
                        //  使用 standard 分词器分割单词
                        "tokenizer":    "standard",
                        //  使用 lowercase 标记过滤器将词转为小写 —— lowercase
                        //  用 stop 标记过滤器去除一些自定义停用词 —— my_stopwords
                        "filter":       [ "lowercase", "my_stopwords" ]
                    }
                },
              
                //  ②【分词器】一个分析器 必须 包含一个分词器,分词器将字符串分割成单独的词（terms）或标记（tokens）
                //    standard 分词器将字符串分割成单独的字词，删除大部分标点符号
                //    keyword 分词器输出和它接收到的相同的字符串，不做任何分词处理
                //    whitespace 分词器]只通过空格来分割文本
                //    pattern 分词器]可以通过正则表达式来分割文本
              
                //  ③【标记过滤器】分词结果的 标记流 会根据各自的情况，传递给特定的标记过滤器
                //    stemmer 标记过滤器将单词转化为他们的根形态（root form）
                //    ascii_folding 标记过滤器会删除变音符号，比如从 très 转为 tres
                //    ngram 和 edge_ngram 可以让标记更适合特殊匹配情况或自动完成
                //    lowercase 标记过滤器
                //    stop 标记过滤器
              
            }
        }
    },
    "mappings": {
        "type_one": { ... any mappings ... },
        "type_two": { ... any mappings ... },
        ...
    }
}
    
```