# 分词

## 说明

## standard Analyzer

standard analyzer 是所有全文搜索的string字段的默认分析器，如果没有特殊定义。

```
{
    "type":      "custom",
    "tokenizer": "standard",
    "filter":  [ "lowercase", "stop" ]
}
```

这是他的模拟。

## standard Tokenizer

The `whitespace` tokenizersimply breaks on whitespace—spaces, tabs, line feeds,

```
You're the 1st runner home!
>>
You're, the, 1st, runner, home!
```



The `letter` tokenizer, on the other hand, breaks on any character that is not a letter, and so would return the following terms:

```
You're the 1st runner home!
>>
You, re, the, st, runner, home.
```



The `standard` tokenizer uses the Unicode Text Segmentation algorithm (as defined in [Unicode Standard Annex #29](http://unicode.org/reports/tr29/)) to find the boundaries *between* words, and emits everything in-between. 

```
You're my 'favorite'.
>>
You're, my, favorite.
```

## Tidying Up Text

分词前可以使用char_filters, 如 html_strip

## Normalizing Tokens

标准化的过程是为了让搜索更加准确，想象相近的东西被标准化为一样的东西，则我们就能够实现搜索相近的东西了。如lowercase，stop等。

