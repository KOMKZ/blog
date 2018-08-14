# es中英文 全文搜索实践

## 预备知识

### 依赖

1. 安装好elasticsearch，我选择的版本是2.4版本，查看另外一篇文章安装es及相关插件
2. 安转好php的es扩展，这里我选择php的elasticsearch/elasticsearch
3. 准备一个好心情

### 预备知识

1. 了解索引，类型，文档的定义
2. 了解索引构建的基本流程
3. 了解查询匹配的基本流程
4. 了解基本api

## 磨刀霍霍向猪羊

这个小节中，我们先准备一些预备工作，如下：

1. 执行脚本则安装索引

   ```
   ./yii job/run 0_1
   ```

2. 执行脚本则可以实现搜索

   ```
   ./yii job/search-all 0_1 hello
   ```

3. 保存多个版本的构建过程，所以我们以下数据结构,数组的键值`0_1`是版本号,最终详细内容可以参考附件(todo)，每次测试不同版本都可以直接保存在这里，方便测试学习。

   ```php
   <?php
   // @app/config/es-defs/0_1.php
   return [
       'index' => ... // 索引的名称
       'body' => ... // 索引的设置,包括分析器的定义在这里面
       'mapping' => ... // 映射设定
       'query' => ... // query语句设定
       'data' => ... // 假数据
   ];
   ```

上述内容关联的文件如下：

```
JobController.php
main.php
```

## 0_1-测试best_fields,most_fields,cross_fileds

预期：

```
best_fields: 搜索的文本在字段中得到最好的匹配，则该条文档的分数越大
most_fields: 搜索的文本出现在越多的字段中，则该条文档的分数越大，逻辑主要是multi_query,然后使用或逻辑，其中可以指定字段的匹配权重
cross_fields: 
```

**测试点：best_fields同most_fields的主要差别**

****使用most_fields查询，1分数高因为文本在大多数字段中都出现，自然比2要好。

```json
源文档如下
created_at:    1534239611
id:            1
create_uname:  国
               国
title:         中
               中
content:       人
               人

created_at:    1534239611
id:            2
create_uname:  
title:         中国人
               中国人
content:       

得分如下
id type           score       h_count   text
1  most_fields    0.19723237  3         中国人
2  most_fields    0.09861618  1         中国人
```

使用best_fields查询，2分数更高是因为title的匹配很好，自然比1要分数高。

```
源文档如下
created_at:    1534239611
id:            2
create_uname:  
title:         中国人
               中国人
content:       

created_at:    1534239611
id:            1
create_uname:  国
               国
title:         中
               中
content:       人
               人

得分如下
id type           score       h_count   text
2  best_fields    0.4534806   1         中国人
1  best_fields    0.12845722  3         中国人

```



















