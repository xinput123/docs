#### 1、Node和Cluster
Elastic本质上是一个分布式数据库，允许多台服务器协同工作，每台服务器可以运行多个Elastic实例。

单个Elastic实例称为一个节点(node)。一组节点构成一个集群(cluster).

<br/>

#### 2、Index
Elastic会索引所有字段，经过处理后写入一个反向索引。查找数据的时候，直接查找该索引。所以，Elastic数据管理的顶层单位就叫做Index(索引)。它是单个数据库的同义词。每个Index(即数据库)的名字必须是小写。

<br/>

#### 3、Document
Index里面单条的记录称为Document(文档)。许多条Document构成了一个Index。Document使用JSON格式表示。

<br/>

#### 4、Type
Document 可以分组，比如weather这个 Index 里面，可以按城市分组（北京和上海），也可以按气候分组（晴天和雨天）。这种分组就叫做 Type，它是虚拟的逻辑分组，用来过滤 Document。

不同的 Type 应该有相似的结构（schema），举例来说，id字段不能在这个组是字符串，在另一个组是数值。这是与关系型数据库的表的一个区别。性质完全不同的数据（比如products和logs）应该存成两个 Index，而不是一个 Index 里面的两个 Type（虽然可以做到）。