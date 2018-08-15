# es权威指南实操系列

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

### 相关资源

```
# es权威指南 中文
https://www.elastic.co/guide/cn/elasticsearch/guide/current/index.html
# es2.4参考手册 
https://www.elastic.co/guide/en/elasticsearch/reference/2.4/index.html
```



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

## 0_1 索引建立，查询流程

相关api：

```
# 分析分词效果可以
http://localhost:9200/{indexName}/_analyze
```



创建索引及映射：

导入数据：

基本查询：

## 探究中文索引的建立和查询

## 中英搜索的常见要求及构建流程















