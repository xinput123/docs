### 以下数据在mysql5.6版本，5.7进行了很多优化

# 一、准备数据
```
// actor
DROP TABLE IF EXISTS `actor`;
CREATE TABLE `actor` (
 `id` int(11) NOT NULL,
 `name` varchar(45) DEFAULT NULL,
 `update_time` datetime DEFAULT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `actor` (`id`, `name`, `update_time`) VALUES (1,'a','2017-12-22 15:27:18');
INSERT INTO `actor` (`id`, `name`, `update_time`) VALUES (2,'b','2017-12-22 15:27:18');
INSERT INTO `actor` (`id`, `name`, `update_time`) VALUES (3,'c','2017-12-22 15:27:18');



// film
DROP TABLE IF EXISTS `film`;
CREATE TABLE `film` (
 `id` int(11) NOT NULL AUTO_INCREMENT,
 `name` varchar(10) DEFAULT NULL,
 PRIMARY KEY (`id`),
 KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `film` (`id`, `name`) VALUES (3,'film0');
INSERT INTO `film` (`id`, `name`) VALUES (1,'film1');
INSERT INTO `film` (`id`, `name`) VALUES (2,'film2');



// film_actor
DROP TABLE IF EXISTS `film_actor`;
CREATE TABLE `film_actor` (
 `id` int(11) NOT NULL,
 `film_id` int(11) NOT NULL,
 `actor_id` int(11) NOT NULL,
 `remark` varchar(255) DEFAULT NULL,
 PRIMARY KEY (`id`),
 KEY `idx_film_actor_id` (`film_id`,`actor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `film_actor` (`id`, `film_id`, `actor_id`) VALUES (1,1,1);
INSERT INTO `film_actor` (`id`, `film_id`, `actor_id`) VALUES (2,1,2);
INSERT INTO `film_actor` (`id`, `film_id`, `actor_id`) VALUES (3,2,1);
```

- 1、actor(演员表):id、name(演员名字)、update_time(修改时间)
- 2、film(电影表): id(主键自增)、name(电影名称)、idx_name(索引名称，以name字段为索引)
- 3、film_actor（电影表和演员的关联表）：id（id主键不自增）、film_id（电影id）、actor_id（演员id）、remark（备注）、idx_film_actor_id（索引名称、以film_id和actor_id的联合索引）


# 二、执行
```
explain select (select id from actor limit 1) from film;
```
![image.png](https://upload-images.jianshu.io/upload_images/4046640-89adf04c8eed508f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 1、id列
id列的编号是select的序列号，有几个select就有几个id，并且id的顺序是按照select出现（执行）顺序增长的。MySql将select查询分为简单查询（SIMPLE）和复杂查询（PRIMARY）。

复杂查询分为三类：简单子查询、派生(from语句中的子查询)、union查询

**id列的值越大，执行优先级越高，id相同则从上往下执行，id值如果为NULL则最后执行。**

#### 1-1、简单子查询
```
explain select (select id from actor limit 1) from film;
```
> 这个简单的子查询先查询actor表后查询film表

#### 1-2、from字句中的子查询
```
explain select * from (select id from film where 1=1) a;
```
![image.png](https://upload-images.jianshu.io/upload_images/4046640-57754a773f246f8b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 这个查询执行时有个临时表别名为der，外部 select 查询引用了这个临时表

#### 1-3、union查询
```
explain select id from actor union all select id from actor;
```
![image.png](https://upload-images.jianshu.io/upload_images/4046640-0726549b6fa92ae0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> union结果总是放在一个匿名临时表中，临时表不在SQL中出现，因此它的id是NULL。


## 2、select_type列
**select_type表示对应行的查询类型是简单查询还是复杂的查询，如果是复杂的查询，又是上述三种的哪一种**

- 1、simple : 简单查询，查询不包含子查询和union
- 2、primary : 复杂查询中最外层的select
- 3、subquery : 包含在select中的子语句(不在from子语句中)
- 4、derived : 包含在from子句中的子查询。Mysql会将结果存放在一个临时表中，也称之为派生表
- 5、union : 在union 中的第二个和随后的select
- 6、union result : 从union临时表检索结果的select


## 3、table列
这一列表示 explain 的一行正在访问哪个表。**当 from 子句中有子查询时，table列是 < derivedN > 格式，表示当前查询依赖 id=N 的查询，于是先执行 id=N 的查询。当有 union 时，UNION RESULT 的 table 列的值为<union1,2>，1和2表示参与 union 的 select 行id。**


## 4、type列
这列表示关联类型或访问类型，即MySQL决定如何查找表中的行，查找数据行记录的大概范围。**查询效率最优到最差分别为：system > const > eq_ref > ref > range > index > ALL**。一般来说，得保证查询达到range级别，最好达到ref。

这个type也可能出现NULL值，NULL值是mysql能够在优化阶段分解查询语句，在执行阶段用不着再访问表或索引。例如：在索引列中选取最小值，可以单独查找索引来完成，不需要在执行时访问表。


#### 4-1、system和const
```
explain select * from (select * from film where id = 1) tmp;
```
![image.png](https://upload-images.jianshu.io/upload_images/4046640-38afbe9921a1a31e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- mysql能对查询的某部分进行优化并将其转化成一个常量（可以看show warnings 的结果）。用于 primary key 或 unique key 的所有列与常数比较时，所以表最多有一个匹配行，读取1次，速度比较快。system是const的特例，表里只有一条元组匹配时为system。

- 从上图可知id为2随对应的是select * from film where id = 1这条sql先执行，这条sql是根据主键id去查询的，所以这条sql只能查询出来一条记录。 对于查询语句，如果它的where条件是根据主键索引或者唯一索引去查询的，能够明确的知道查询出的结果是只有一条记录，那么它的type值就是const类型。

- 在id值为1的记录，type值为system，它的table值为衍生表< derived2 >，但是这个衍生表很明确的只有一条记录，那这里相当于就是一个常量了。
在mysql执行sql语句之前，它会有一个分析与优化，mysql知道你的这个衍生表中只有一行记录，针对于这样的select情况，它的type就是system。system可以说是const的一个特例。system和const有什么区别呢？const所对应的sql所查询的表可以有很多记录，但是const所对应sql查询出来的结果集只有一条。system所对应sql通过mysql的分析知道这张衍生表只有一条记录。


#### 4-2、eq_ref : primary key （主键索引）或 unique key（唯一索引）
```
explain select * from film_actor left join film on film_actor.film_id = film.id;
```
![image.png](https://upload-images.jianshu.io/upload_images/4046640-356bfc05fd2cea6e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> primary key （主键索引）或 unique key（唯一索引） 的所有部分被连接使用 ，最多只会返回一条符合条件的记录。这可能是在 const 之外最好的联接类型了

#### 4-3、ref: 普通索引
相比 eq_ref，不使用唯一索引，而是使用普通索引或者唯一性索引的部分前缀，索引要和某个值相比较，可能会找到多个符合条件的行。

#### 4-4、range: 范围扫描通常出现在 in(), between ,> ,<, >= 等操作中。使用一个索引来检索给定范围的行。

#### 4-5、index: 扫描全表索引
index从索引中读取，而all从硬盘中读取

#### 4-6、all: 全表扫描


## 5、possible_keys列
这一列显示查询可能使用哪些索引来查找。explain 时可能出现 possible_keys 有列，而 key 显示 NULL 的情况，这种情况是因为表中数据不多，mysql认为
索引对此查询帮助不大，选择了全表查询。

如果该列是NULL，则没有相关的索引。在这种情况下，可以通过检查 where 子句看是否可以创造一个适当的索引来提高查询性能，然后用 explain 查看效果。


## 6、keys列
这一列显示mysql实际采用哪个索引来优化对该表的访问。如果没有使用索引，则该列是NULL。如果想强制mysql使用或忽视possible_keys列中的索引，在查询中使用 force index、ignore index。


## 7、key_len列
这一列显示了mysql在索引里使用的字节数，通过这个值可以算出具体使用了索引中的哪些列。

#### 7-1、key_len计算规则
##### 字符串
    char(n): n字节长度
    varchar(n): 2字节存储字符串长度，如果是utf8，则长度 3n+2
    
##### 数值类型
    tinyint：1字节
    smallint：2字节
    int：4字节
    bigint：8字节
    
##### 时间类型
    date：3字节
    timestamp：4字节
    datetime：8字节
    
> 如果字段允许为 NULL，需要1字节记录是否为 NULL 索引最大长度是768字节，
当字符串过长时，mysql会做一个类似左前缀索引的处理，将前半部分的字符提取出来做索引。    


## 8、ref列
这一列显示了在key列记录的索引中，表查找值所用到的列或常量，常见的有：const（常量），字段名


## 9、rows列
mysql估计要读取并检测的行数，注意这个不是结果集里的行数


## 10、Extra列: 额外的信息
#### 10-1、Using index
查询的列被索引覆盖，并且where筛选条件是索引的前导列，是性能高的表现。一般是使用了覆盖索引(索引包含了所有查询的字段)。对于innodb来说，如果是辅助索引性能会有不少提高；

```
explain select film_id from film_actor where film_id = 1;
```

#### 10-2、Using where 
查询的列未被索引覆盖，where筛选条件非索引的前导列；

#### 10-3、Using where Using index
查询的列被索引覆盖，并且where筛选条件是索引列之一但是不是索引的前导列，意味着无法直接通过索引查找来查询到符合条件的数据；

#### 10-4、NULL
查询的列未被索引覆盖，并且where筛选条件是索引的前导列，意味着用到了索引，但是部分字段未被索引覆盖，必须通过“回表”来实现，不是纯粹地用到了索引，也不是完全没用到索引；

#### 10-5、Using index condition： 
与Using where类似，查询的列不完全被索引覆盖，where条件中是一个前导列的范围；

#### 10-6、Using temporary
mysql需要创建一张临时表来处理查询。出现这种情况一般是要进行优化的，首先是想到用索引来优化。