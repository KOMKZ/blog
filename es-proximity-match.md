# Elasticsearch 相似搜索

## 说明

比如中国国家安全，我们知道这个词可能会被拆成很多部分，我们的查询很可能查询出词间距的很大的记录，也可能查处间距为0的记录，我们希望间距为0的记录排在前面，这就是相似搜索的领域了。

## Phrase Matching

> the`match_phrase` query is the one you should reach for when you want to find words that are near each other:

是的，match_phrase 是设计来匹配短语的，说明中说的问题如果使用match_phrase的话，则会匹配到间距0的记录，不会匹配到存在间距的记录。对于中文也是有效的。

`match_phrase` 作为一个语句，也可以使用match指定type=phrase参数然后达到相同的目地。

文本被索引的时候得到许多的term，这些term是带着postion的，假设 中国的人为索引了，中国的postion就是1, 人的索引就是3。

判定一个短语的条件如下：

> For a document to be considered a match for the phrase “quick brown fox”, the following must be true:
>
> - `quick`, `brown`, and `fox` must all appear in the field.
> - The position of `brown` must be `1` greater than the position of `quick`.
> - The position of `fox` must be `2` greater than the position of `quick`.
>
> If any of these conditions is not met, the document is not considered a match.

## Mixing It Up

`match_phrase` 作为匹配来说，还是相对非常的严格的，但是我们可以通过参数slop来控制这个程度。

slop参数表示允许词之间的间距为多少认为是匹配。比如：

对于`中国的安全领域`来说，slop=3 能够匹配到 `中国领域`，但是为了匹配到`领域中国` 则必须再次提高slop的值，领域 要向左移动， 中国要向右移动。

## Multivalues Feilds

对于一些多值的字段，如 ['kitral zhong', 'Yin Zhang'], 被索引的时候得到postion是 0,1,2,3, 这导致 使用 `match_phrase` 能够匹配到 `zhong yin` ，这明显是不好的，所以应该定义一下 `position_increment_gap`

参数，（必须在mapping中定义），如果定义为10, 则postion为 0，1, 11, 12。这样子就很好的解决了这个问题了。

## Closer Is Better

之前说过，相似度不要作为排序的主要，但是我们可以利用他来加分，我们使用match_phrase放在should语句中，提高一定的slop值，用来表达如果搜索的内容和记录越相近，将有越好的得分。

## Improving Proformance

由于需要许多的计算，相似搜索对性能有一定的影响，应该考虑减少需要计算的记录数量，将较为严格的条件放在前面。

```
                'rescore' => [
                    'window_size' => 50,
                    'query' => [
                        'rescore_query' => [
                            'match_phrase' => [
                                'title' => [
                                    'query' => $str,
                                    'slop' => 20
                                ],
                                'content' => [
                                    'query' => $str,
                                    'slop' => 30
                                ]
                            ]
                        ]
                    ]
                ],
```

无语，居然报错（todo）

Elasticsearch\Common\Exceptions\BadRequest400Exceptionillegal_argument_exception: rescore doesn't support [query]

## Finding Assocation

todo

