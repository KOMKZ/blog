# Getting Started With Human Languages

## 说明

（todo本文不完整）

全文搜索是获取尽可能少不相关的文档（precision）和尽可能获取可能相关的文档（recall）之间的斗争。

这之间重要的是对文本进行索引：

1. 标识词汇，分词问题 Indetifying Words
2. 规范词汇, Normalzing Tokens
3. 过滤词汇，加入和删除词汇

这里需要注意一般来说，分析器都会做以下事情，特殊的分析器会做一些特定的事情，如语言相关。

1. 文本过滤：过滤标签等
2. 分词
3. 过滤（标准化过程），lowercase, 提取原型等

## Pitfalls of Mixing Languages

混合语言的全文搜索一般会遇到以下问题

### At Index Time

1. 不能正确的提取词干，西方语言很明显
2. 索引的文档频率词难以计算，不知道使用拿个语料库。

### At Search Time

（todo）



