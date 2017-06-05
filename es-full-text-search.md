# Elasticsearch全文搜索

## 说明
## The Match Query

> It is a high-level full-text query, meaning that it knows how to deal with both full-text fields and exact-value fields.

match query 是上层的query，即他能够智能识别字段的类型而使用不同的匹配方式，更加具体的说，就是他会识别的使用底层的query，如Struct Query的内容。比如match语句可能底层会简单的使用term语句，应为查询的token是一个单一的字符串。

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