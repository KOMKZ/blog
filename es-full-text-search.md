# Elasticsearch全文搜索

## 说明
## The Match Query

> It is a high-level full-text query, meaning that it knows how to deal with both full-text fields and exact-value fields.

match query 是上层的query，即他能够智能识别字段的类型而使用不同的匹配方式，更加具体的说，就是他会识别的使用底层的query，如Struct Query的内容。比如match语句可能底层会简单的使用term语句，应为查询的token是一个单一的字符串。

默认逻辑是或，可以使用以下参数变成与

```
"operator": "and"
```

用以下参数来提高单词的匹配数量：

```
"minimum_should_match": "75%"
```

## Multiuwords Query

为什么说match query比较只能呢？比如查询多个词的时候match query会自动使用bool结合多个term子句来查询。这也是说他是上层query语句的原因。

> Perhaps we want to show only documents that contain *all* of the query terms. In other words, instead of `brown OR dog`, we want to return only documents that match `brown AND dog`.

match语句默认是使用or的逻辑，也就是说匹配到一个词就算是匹配，我们可以使用与的形式来提高搜索的精度，如下所示：

```
GET /my_index/my_type/_search
{
    "query": {
        "match": {
            "title": {      
                "query":    "BROWN DOG!",
                "operator": "and"
            }
        }
    }
}
```

可以使用以下形式来达到精度更灵活的控制：

```
GET /my_index/my_type/_search
{
  "query": {
    "match": {
      "title": {
        "query":                "quick brown dog",
        "minimum_should_match": "75%"
      }
    }
  }
}
```
## Combining Queries

和filter不同的是，filter中的should依旧是决定一条记录是不是应该被包含或者排除，而query中的should不决定记录包含和排除，而是会增加记录的得分，这是很明显的不同。注意一种特殊的情况是当must没有匹配的时候，则should可以影响记录的包含和排除。（再次提醒一下match的默认逻辑的是或，可以通过参数控制精度）

可以利用这个来使记录的排名考前。

```
GET /my_index/my_type/_search
{
  "query": {
    "bool": {
      "must":     { "match": { "title": "quick" }},
      "must_not": { "match": { "title": "lazy"  }},
      "should": [
                  { "match": { "title": "brown" }},
                  { "match": { "title": "dog"   }}
      ]
    }
  }
}
```

> The results from the preceding query include any document whose `title` field contains the term`quick`, except for those that also contain `lazy`. So far, this is pretty similar to how the `bool` filter works.

must_not 不影响得分，must和should可以增加得分，一个bool语句会将所有must的得分和should的得分加起来，然后除以must和should的数量。注意bool是可以嵌套的。

当然我们也可以通过 minimum_should_match 来控制 should字句必须匹配的数量。注意参数的位置，该参数是属于bool的。

```
    "bool": {
      "should": [
        { "match": { "title": "brown" }},
        { "match": { "title": "fox"   }},
        { "match": { "title": "dog"   }}
      ],
      "minimum_should_match": 2 
    }
```

## How Match Uses Bool

之前说过match字句是一个上层封装的方法，底层是term还有bool等语句的组合。其中的and参数，还有精度控也都是通过相互转换的得到的。

## Boosting Query Clause

使用boost来提高分数，0-1来减分数，大于1来提高分数，变化是不是线性的。

## Controlling Analysis

一般来说存储时的分析和搜索时的分析需要匹配。但这并不是必须，如果没有指定，一般来说是用配置时的分析，另外如果配置时也没有指定，则使用类型，索引，节点上的默认分析。

分析器有三种级别：字段级别，索引级别，全局级别。

索引时分析器的寻找过程：

1. 如果字段定义中有，则使用，如果没有，则继续寻找
2. 使用索引设置中名为default的分析器，一般来说就是standard

更加完整的过程：

- The `analyzer` defined in the query itself, else
- The `search_analyzer` defined in the field mapping, else
- The `analyzer` defined in the field mapping, else
- The analyzer named `default_search` in the index settings, which defaults to
- The analyzer named `default` in the index settings, which defaults to
- The `standard` analyzer

搜索时的分析器的寻找过程：

1. 搜索语句中查找，没有则继续
2. 字段映射定义中查找，没有则继续
3. 索引设置中名为default的分析器，一般是standard

可以使用`search_analyzer` 在定义的时候就指定搜索时期的分析器。

## Relevance Is Broken

todo