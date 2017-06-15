# 控制相关度

## 相关度计算

文档相关度计算关键如下：

1. 使用Boolean模型来筛选出doc，其实就是`bool` query。

2. 接着考虑使用计算doc的得分来实现doc的排序。

3. doc的得分依赖于各个query中的term在doc中的权重，所以这里需要关注term在doc中权重的计算，还有各个query的权重。

   term在doc（理解成field中内容）中权重的计算fator：

   term frequency:词频，即该term在doc中出现的次数，es使用公式，出现的次数越高，tf越高。

   ```
   tf(t in d) = √frequency 
   ```

   inverse term frequency: 该term在所有的doc中出现越多，权重越低	

   ```
   idf(t) = 1 + ln ( maxDocs / (docFreq + 1)) 
   ```

   field norm: 搜索term数量，越长说明权重会越小。

   ```
   norm(d) = 1 / √numTerms 
   ```

   上面是term权重的计算因素，真正的公式叫做*practical scoring function*

4. 上面计算到了term的权重，合并多个term的权重，就能得出这个doc关于一个query的得分，但是一般来说

   我们是有多个query的，所以需要使用vector space model来计算多个query对于doc的分数。

   [vecotr space model](https://www.elastic.co/guide/en/elasticsearch/guide/current/scoring-theory.html#vector-space-model)

practical scoring function公式说明：

理解以下概念：

query normalization fator:

这个fator是将query的结果转变成能够用于于另外一个转变过的query结果的东西。在query之前被计算。公式如下，

```
queryNorm = 1 / √sumOfSquaredWeights 
```

其中sumOfSquaredWeights就将query中的term的idf权重都加起来。





