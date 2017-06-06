# Elasticsearch 多字段搜索

## 说明

## Multple Query String

多个查询字符串的查询场景有许多。

场景1：明确知道各个查询字符串的应该对应那个字段

使用match和bool组合能够达到目地。

看一个分数的计算场景：

```
    "bool": {
      "should": [
        { "match": { "title":  "War and Peace" }},
        { "match": { "author": "Leo Tolstoy"   }},
        { "bool":  {
          "should": [
            { "match": { "translator": "Constance Garnett" }},
            { "match": { "translator": "Louise Maude"      }}
          ]
        }}
      ]
    }
```

其实都是should，为什么内层还要用一个should包围住两个match条件呢？没错就是为了影响分数的计算。

> The answer lies in how the score is calculated. The `bool` query runs each `match` query, adds their scores together, then multiplies by the number of matching clauses, and divides by the total number of clauses. Each clause at the same level has the same weight. In the preceding query, the `bool`query containing the translator clauses counts for one-third of the total score. If we had put the translator clauses at the same level as title and author, they would have reduced the contribution of the title and author clauses to one-quarter each.

上面这段话中，解释到每个子句的得分是1/3, （第一级），第二级是1/6, 如果将第二级放在第一级，则会下降成为1/4。注意这是控制分数影响的手段。

需要注意的是在这个例子中1/3将重要均等的，但是如果我们需要控制前两个的重要性，则可以使用boost参数去控制。

## Single Query String

对于单一字符串在跨字段搜索中，我们需要了解我们的数据形式，选择合适的方法来查询。这种场景典型是综合搜索输入框。

对于综合搜索来说，我们需要对我们的数据有所了解指定最优的策略。一般来说我们考虑的角度如下：

从最佳字段匹配来考虑，最佳字段就是最重要字段，最重要字段的匹配分数为最终分数

从最多字段匹配来考虑。

## Best Field

```
PUT /my_index/my_type/1
{
    "title": "Quick brown rabbits",
    "body":  "Brown rabbits are commonly seen."
}

PUT /my_index/my_type/2
{
    "title": "Keeping pets healthy",
    "body":  "My quick brown fox eats rabbits on a regular basis."
}
```

当我们查询 brown fox这个内容的时候，一般来说记录2应该得分更高，记录1得分低，如果使用常规的查询should和match普通组合，则会得到相反的结果，所以我们可以使用以下语句：

```
{
    "query": {
        "dis_max": {
            "queries": [
                { "match": { "title": "Brown fox" }},
                { "match": { "body":  "Brown fox" }}
            ]
        }
    }
}
```

但是这里有一个问题，就是dis_max始终只取一个字段作为最佳字段，其他字段有更多的匹配也不能够影响得分了。

## Turning The Best Fields Queries

上述的问题其实我们可以通过加参数来表现：

```
{
    "query": {
        "dis_max": {
            "queries": [
                { "match": { "title": "Quick pets" }},
                { "match": { "body":  "Quick pets" }}
            ],
            "tie_breaker": 0.3
        }
    }
}
```

tie_breaker 这个参数表示 dis_max和bool的靠近程度，范围0-1，数值越大越靠近，实际的计算公式如下：

1. Take the `_score` of the best-matching clause.
2. Multiply the score of each of the other matching clauses by the `tie_breaker`.
3. Add them all together and normalize.

## multi_query Query

我们可以使用以下的方式来更加紧凑的表达：

```
{
    "multi_match": {
        "query":                "Quick brown fox",
        "type":                 "best_fields", 
        "fields":               [ "title", "body" ],
        "tie_breaker":          0.3,
        "minimum_should_match": "30%" 
    }
}
```

其中fields 参数可以使用 通配符 "fields": "*_title"

也可以使用表达boost数值，如 "fields": [ "*_title", "chapter_title^2" ] 

## Most Fileds

提高文档的召回率recall，就是尽可能的召回可能相关的文档，不仅仅是字面上的匹配，还可以是意思上的匹配，如同义词召回。

提高召回率的同时我们需要使精度提高。

这里有个策略是定义多个子字段，主字段用来匹配较多的内容，用子字段来提升进度。当然要注意子字段和主字段的boost影响，我们可以设置书字段更多的影响如 title^10

首先，定义一个映射包含子字段的：

```
DELETE /my_index

PUT /my_index
{
    "settings": { "number_of_shards": 1 }, 
    "mappings": {
        "my_type": {
            "properties": {
                "title": { 
                    "type":     "string",
                    "analyzer": "english",
                    "fields": {
                        "std":   { 
                            "type":     "string",
                            "analyzer": "standard"
                        }
                    }
                }
            }
        }
    }
}
```

然后查询

```
GET /my_index/_search
{
   "query": {
        "multi_match": {
            "query":  "jumping rabbits",
            "type":   "most_fields", 
            "fields": [ "title", "title.std" ]
        }
    }
}
```

## Cross-Fields Entity Search

很明显best_fields的方法是错的，使用most_fields的方法也是不合适的，为什么以为？most_fields是设计来提高精度的，是为了让匹配的记录通过most_fields能够获取更好的得分。

对于cross fields 的需求是，用户希望通过一个搜索字符串，将包含该字符串的字段的所有document查询出来，是most_fields 是有些差别。

>All three of the preceding problems stem from `most_fields` being *field-centric* rather than *term-centric*: it looks for the most matching *fields*, when really what we’re interested in is the most matching *terms*.

这点差别还可说成，most_fields的查询是为了查询记录，这些记录拥有许多能够匹配到字符串的字段，但我们关注的重点是希望这些记录能够尽可能多的匹配字符串，区别在于一个是匹配字符串的更多，一个是匹配字段的更多。而这一切的问题都是因为以字段为中心而产生的。叫做field-centric, 而我们关注的重点是term-centric。

第一个问题，比如如果我们查询`中国国家安全`，在记录1中有两个字段分享了这个词，记录2中有一个字段分享了这个词，正常情况下，记录2的得分必须要高，但是因为most_fields，所以记录1的得分会高。当然你说可以增加子字段的方式来提升记录2, 但是这却不是根本的解决方法。而使用最佳字段的方法则会让得分都相同，假设有几条数据匹配的话。

第二个问题，试图通过and，还有minimum_should_match来提升的都是错误的，不应该认为这些字符串只能都存在某个字段中，综合搜索的用户的搜索的内容是可能分布在各个字段当中的。如 小明 家是中国，标题可能含有小明，家是中国可能在文章当中。如果通过and或者minimum_should_match，则说明 这两个词要么都在一个字段中。

第三个问题，就是tf/idf的问题，（todo）

解决方案就是建立新的字段，将所有的内容合并在这个字段中，然后使用常规的查询去查询这个字段。

可以在index时期和search时期做这个事情。

## Custom _all Fields

在索引的时候通过以下的方法定义_all字段

```
PUT /my_index
{
    "mappings": {
        "person": {
            "properties": {
                "first_name": {
                    "type":     "string",
                    "copy_to":  "full_name" 
                },
                "last_name": {
                    "type":     "string",
                    "copy_to":  "full_name" 
                },
                "full_name": {
                    "type":     "string"
                }
            }
        }
    }
}
```

注意，不能使用copy_to参数在一个包含子字段的字段中。

full_name的索引的方式是独立的，不合其他字段有关系。

也可以在查询的时候指定cross_fields值。

```
GET /_validate/query?explain
{
    "query": {
        "multi_match": {
            "query":       "peter smith",
            "type":        "cross_fields", 
            "operator":    "and",
            "fields":      [ "first_name", "last_name" ]
        }
    }
}
```

