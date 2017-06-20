# mongo aggregate 语法学习笔记

## 基本概念

1. 管道  
    将文档集合通过管道传输到不同的操作进行运算，得到最终的集合。其中类似`$match`, `$project`都是aggregate中的不同操作。集合流传递到操作上，然后每个文档也会传递到该操作上。
2. 表达式
    1. 表达式允许内嵌，表达式中可以继续使用表达式，
    2. 不同的操作有不同支持的表达式
    3. 支持"$children.0.name"来获取值
    4. 支持系统变量的访问，如"$$current.children.0.name"等同于上面，更多[系统变量](https://docs.mongodb.com/v3.0/reference/aggregation-variables/#variable.CURRENT)
    5. 了解不同的[操作表达式的使用](https://docs.mongodb.com/v3.0/meta/aggregation-quick-reference/#aggregation-expressions)

## 不同操作用途简介
1. $match
    1. 主要用于筛选文档获得子集
2. $project
    1. 只选出集合的某些字段
    2. 重命名某些字段
    3. 对字段进行各种不同表达式的计算，加入许多的逻辑，最终得到新的值用于返回。
3. $group
    1. 对集合进行分组，运用不同的分组操作可以产生特定的分组文档。
4. $unwind
    1. 迭代每个传递进来的文档，对其文档的某个数组类型的字段释放他的元素作为新的集合
5. $sort
    1. 根据某些字段对集合进行排序，1：a-z, -1:z-a
6. $limit
    7.


## 不同操作说明
每种操作都有自己特定的表达式，注意表达式的使用方式和阅读有哪些表达式可以使用，可以使得aggregrate变得非常强大，甚至能够处理业务。这个小节主要
说说不同操作之间的一些说明，一些注意的点。
### $project
1. $project的参数是最终返回的文档形式，你可以通过结合不同的表达式运算出不同的文档从而决定集合的样子。
2. Mongodb doesn't track field name history when field are renamed. Thus, if you had an index on `originalFieldName`, aggregate would be unable to use use index for the sort below.thus, try to utilize indexes before changeing the names of fields.

### $group
分组是另外一种产生集合的方式，内部的机制是依赖某种分组字段，对文档进行归类，产生归类文档，每次归类一条文档的时候
，本操作将有机会对文档进行访问，比如获取值用于归类文档的计算。所以有一些不同的表达式。
注意每次操作的表达式不是及时计算的，如下面收益的平均值的计算不会在每次的迭代中都计算，所以我设想这里是统一计算的。
```
db.country_sales.aggregate(
    {
        "$group" : {
            "_id" : "$country_name",
            "avg_revenue" : {
                "$avg" : "$revenue"
            }
        }
    }
    );
```

### $unwind
$unwind能够迭代每个传递进来的文档，对其文档的某个数组类型的字段释放他的元素作为新的文档，也就是说该字段拥有3个元素，$unwind之后就会变成
3个文档，分散出去。
