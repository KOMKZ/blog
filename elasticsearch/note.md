> use filtering query as often as we can, because it doesn't caculate relevence.

>  the `term` query will look exact value we specified.

> we will use a `constant_score` query to execute the `term` query in a non-scoring mode and apply a uniform score of one. (which is 1)
>
> ```
> {
>     "query" : {
>         "constant_score" : { 
>             "filter" : {
>                 "term" : { 
>                     "price" : 20
>                 }
>             }
>         }
>     }
> }
> ```

>  use analyze api in php
>
> ```
> $params = [
>   'index' => 'db1',
>   // 这里有很多参数可以参考api文档
> ];
> $client->indices()->analyze($params)
> ```
>
> 



