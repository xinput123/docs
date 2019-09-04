MongoDB聚合操作用于对数据的批量操作，将集合按条件分组后在进行一系列操作，诸如求和、求均值等。聚合操作能对集合进行复杂的操作，主要用于数理统计和数据挖掘。MongoDB中聚合操作的输入是i集合中的文档，输出可以是一个文档，也可是多条文档。MongoDB提供非常强大的聚合操作，可分为三种方式：

- 聚合管道（Aggregation Pipeline）
- 单目聚合操作（Single Purpose Aggregation Operation）
- MapReduce 编程模型

## 一、聚合管道
POSIX多线程使用方式中，有种叫做管道（流水线）的方式，其数据元素流串行地被一组线程按顺序执行。

聚合管道由阶段（Stage）组成，文档在一个阶段处理完毕后，聚合管道会把处理结果传到下一个阶段。聚合管的功能
- 对文档进行过滤，查询出符合条件的文档。
- 对文档进行变换，改变文档的输出形式。

聚合管道的每个阶段使用阶段操作符（Stage Operators）定义，在每个阶 段操作符中可使用表达式操作符（Expression Operators）计算总和、 均值、拼接或分割字符串等操作，直到每个阶段完结最后返回结果，返回的结果可直接输出，也可存储到集合中。

![image](https://upload-images.jianshu.io/upload_images/4933701-1d32109f70a8c0de.png?imageMogr2/auto-orient/)

#### 处理流程
- b.collection.aggregate() 可同时使用多个管道，方便数据处理。
- db.collection.aggregate() 使用 MongoDB 内置原生操作,聚合效率高且支持类似SQL中 GroupBy的操作, 不在需要用户编写自定义的JS例程。
- 每个阶段管道限制100M的内存，若单节点管道超出极限，MongoDB产生错误。为了能够处理大型数据集，可设置 allowDiskUse 为 true 为聚合管道节点把数据写入临时文件，以解决100M内存限制。
- db.collection.aggregate() 可作用于分片集合，但结果不能输在分片集合， MapReduce可作用于在分片集合其结果也可输在分片集合中。
- db.collection.aggregate() 返回一个指针（cursor），数据存放在内存中可直接操作， 跟MongoShell一样。
- db.collection.aggregate() 输出的结果只能保存在文档中，BSON Document大小限制为16M。

## 语法解析
```
db.collection.aggregate(pipeline, options)

db.collection.aggregate([{<stage>,...}], ...)
```

##### pipeline 参数
- **$project:** 对输入文档添加新字段或删除现有字段，可自定义显示哪些字段。
- **$match:** 根据条件过滤仅输出符合条件的文档，若放在pipeline前面，根据条件过滤数据并传输到写一个阶段管道，可提高后续数据处理效率。也可放在out之前用以对结果再一次过滤。
- **$redact:**  字段所处的document结构的级别
- **$limit:**  用来限制MongoDB聚合管道返回的文档数量
- **$skip:**  在聚合管道中跳过指定数量的文档并返回剩余的文档
- **$unwind:**  将文档中某个数组类型字段拆分成多条，每条包含数组中的一个值。
- **$sample:**  随机选择从起输入指定数量的文档，若大于或等于5%的collection的文档，$sample进行收集扫描并排序随后选择顶部文件。因此$sample在收集阶段是受排序的内存限制。
- **$sort:**  将输入文档排序后输出
- **$geoNear:**  用于地理位置数据分析
- **$out:**  必须为pipeline最后一个阶段管道，将最后计算结果写入到指定collection中。
- **$indexStats:**  返回数据集合的每个索引使用情况
- **$group:**  将集合中的文档分组，可用于统计结果，$group 首先将数据根据 key 进行分组。



## 聚合运算

## mapReduce
mapReduce是一个轻松并行化到多台服务器的聚合方法，它会拆分问题，再将各个部分发送到不同机器上，让每台机器都完成一部分。当所有机器都完成后，再将结果汇集起来形成最终完整的结果。

mapReduce最开始是映射(map)，将操作映射到集合中的每个文档。这个操作要么无作为，要么产生一些键和ｘ个值。接着进入中间环节(洗牌shuffle)，按照分组并将产生的键值组成列表放到对应的键中。化简(reduce)则把列表中的值化简成一个单值。这个值被返回，然后接着进行洗牌，直到每个键的列表只有一个值为止，这个值就是最后的结果。

mapReduce的代价是速度，group不是很快，mapReduce更慢，绝不要用在实时环境中，要作为后台任务运行，将创建一个保存结果的结合，可对这个集合进行实时查询。

##### mapReduce的工作过程

- map 映射：
现将同一个组的数据映射到一个文档（数组）上，在映射环节想要得到文档中每个键，map()使用emit()返回要处理的值。edit()会给mapReduce一个键和一个值，键类似group所使用键key。
- reduce 归约：
将数组（同一组）数据进行运算，reduce()由两个参数，一个是key也就是emit()返回的第一个值，另一个是数组，由一个或多个对应于键的文档构成。reduce()一定要能够被反复调用，不论是映射环节还是前一个简化环节。
