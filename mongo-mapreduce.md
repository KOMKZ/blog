# mongo mapreduce note

## purpose

It can solve some problems that are too complex to express using the aggregation framework's query language.

## feature
It can split up a problem, sends chunks of it to different machines, and lets each machine solve its part of the problem, when all the machines are finished ,they merge all the pieces of the solution back into a full solution.

## 使用方法
1. 使用mapreduce键来指定需要使用的集合
2. 使用map键来准备统计数据，该方法接受一个参数doc，返回一个主键和相关文档。
   文档将被推入到该主键的列表中。
3. 是不是觉得这个列表好长，使用reduce来减少，reduce函数接受两个参数，第一个参数就是key，第二个参数是之前的doc，
   doc从列表中pop，该函数必须返回一个doc重新用于计算，map的doc和reduce的doc数据结构一般相同。
4. reduce最终产生了集合，如果还需要对集合进行最终操作，请使用finalize
5. 输入的集合如果需要永久保存起来的话，可以指定keeptemp为true
6. out指定输出到的临时集合中
7. sort,query,limit这些很明显。
