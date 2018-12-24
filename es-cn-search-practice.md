# es搜索实战

之前写了几篇文章，觉得都是废话，直接上资源还有结果是最好的方法。

分词插件ik

```
# 中文分词插件 ik
https://github.com/medcl/elasticsearch-analysis-ik/tree/2.x 

分析器和分词器都有ik_smart,ik_max_words两种

ik_smart:最粗粒度分词
ik_max_words：穷举组合分词，能得到尽可能多的词

注意：
1. elasticsearch-2.4.3/plugins/ik/config/IKAnalyzer.cfg.xml 配置定义词典能够达到更好的分词效果
```

中文拼音分词插件：

```
# Pinyin Analysis for Elasticsearch
https://github.com/medcl/elasticsearch-analysis-pinyin/tree/2.x
```



一些非常游泳的es的api汇总：

```
# /{indexName}/_analyze?text=中华人民共和国&analyzer=ik_max_word
```

所有我们设定分词器，分析器，过滤器：

```php
<?php
return [
    'analyzer' => [
        
    ]
];
```

我们设定了一个框框，可以执行脚本快速安装和查询，如下：

```
# 相关文件
JobController.php
# 执行下列命令安装数据
# 执行下列命令查询
```

索引构建策略：

```
中
```

