## 一、验证
```
redis-cli

auth  yuan$!   --yuan$!是密码
```

<br/>

## 二、key的操作
```
dbsize   --显示key的数量[][]

keys  *  -- 显示所有的key

keys  nar*  -- 显示所有以 nar开头的key

keys naru?o  -- 显示所有key,如naruto,naruao

EXISTS keyname -- 判断keyname是否存在，存在返回1，不存在返回0

type  keyname  -- 查看key的类型

DEL  keyname  -- 删除key

ttl  key  -- 查看key过期时间。单位为秒  -1没有过期时间  -2没有这个key

flushdb -- 删除当前库所有key

flushall  -- 删除所有库的key
```

<br/>

## 三、数据类型
#### 3-1、String 字符串
```
SET key member --使用set设置key和value的值[][]

setnx key member -- 如果key存在，返回0，如果key不存在，则和set一样，经常用于控制并发

get key -- 获取key的值，如果key不存在，范湖nil

mget key1 key2...  -- 和get一样，一次获取多个[][]
```

<br/>

#### 3-2、Set String类型的无序集合
```
SADD key member[member1][member2]  -- 添加一个或多个string元素到key对一个的集合中[][]

SMEMBERS key  -- 返回key中所有的值，结果是无序的

SCARD   key -- 返回key中元素的个数

SISMEMBER  key  member  -- 判断 member是否存在key对应的set集合中,1在0不在

SREM  key  member -- 删除key对应set中member元素。成功返回1，如果member在对应key中不存在，返回0；如果key对应的集合不是set类型，返回错误[][]
```

<br/>

#### 3-3、ZSET sorted set有序集合，根据插入的score进行排序
```
ZADD key score member [[score member] [score member] ...] -- 将一个或多个member元素及其score值加入到有序集key当中。 如果某个member已经是有序集的成员，那么更新这个member的score值，并通过重新插入这个member元素，来保证该member在正确的位置上。score值可以是整数值或双精度浮点数。如果key不存在，则创建一个空的有序集并执行ZADD操作；当key存在但不是有序集类型时，返回一个错误。

ZCARD key  -- 返回有序集key的个数。当key不存在时，返回0

ZCOUNT key min max -- 返回有序集key中，score值在min和max之间(默认包括score值等于min或max)的成员

ZSCORE key member -- 返回有序集key中，成员member的score值。如果member元素不是有序集key的成员，或key不存在，返回nil

ZRANGE key start stop [WITHSCORES] -- 返回有序集key中，指定区间内的成员。以0表示有序集第一个成员。也可以使用负数下标，以-1表示最后一个成员，以此类推。

ZREVRANGE key start stop [WITHSCORES] -- 返回有序集key中，指定区间内的成员。其中成员的位置按score值递减(从大到小)来排列。用法和ZRANGE一样

ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT offset count] -- 返回有序集key中，所有score值介于min和max之间(包括等于min或max)的成员。有序集成员按score值递增(从小到大)次序排列。默认情况下，区间的取值使用闭区间(小于等于或大于等于)，你也可以通过给参数前增加(符号来使用可选的开区间(小于或大于)

ZREVRANGEBYSCORE key max min [WITHSCORES] [LIMIT offset count] --- 返回有序集key中，所有score值介于min和max之间(包括等于min或max)的成员。有序集成员按score值递增(从小到大)次序排列。和ZRANGEBYSCORE一样用法

ZRANK key member -- 返回有序集key中成员member的排名。其中有序集成员按score值递增(从小到大)顺序排列。排名以0为底，也就是说，score值最小的成员排名为0。使用ZREVRANK命令可以获得成员按score值递减(从大到小)排列的排名

ZREVRANK key member  -- 返回有序集key中成员member的排名。其中有序集成员按score值递减(从大到小)排序。和zrank一样的用法

ZREM key member [member ...] -- 移除有序集key中的一个或多个成员，不存在的成员将被忽略。 当key存在但不是有序集类型时，返回一个错误。 返回值:被成功移除的成员的数量，不包括被忽略的成员。
```

<br/>

#### 3-4、Hash hash表
```
HSET  key  field  value [field1][value1]   --将哈希表key中的域field的值设为value。如果key不存在，一个新的哈希表被创建并进行HSET操作。如果域field已经存在于哈希表中，旧值将被覆盖。

HSETNX  key  field  value -- 这个命令和hset相似。只有在哈希表key中的域不存在，才生效。如果域field存在，此操作无效。

HGET key field -- 返回哈希表key中给定域field的值，不存在返回nil

HMGET key field1 [ field2 field3 ...] -- 返回哈希表key中一个或多个给定域field的值，不存在的返回nil

HGETALL key  返回哈希表key中，所有的域和值。在返回值中，域的值是跟在域名后面的

HLEN  key  -- 查看哈希表key中给定域field是否存在。存在返回1，不存在返回0。

HEXISTS key  field  -- 查看哈希表key中给定域field是否存在。存在返回1，不存在返回0。

HKEYS key --返回哈希表key中的所有域

HVALS key --返回哈希表key中的所有值

HDEL  key  field [field field ... ]  --删除哈希表中的一个或者多个指定域，不存在的域被忽略
```

<br/>

#### 3-5、List 线性表，允许重复元素
```
LPUSH/RPUSH  key  value  [value2 value3..]  --将一个或多个value插入到列表key的表头/表尾。返回值列表的长度

LRANGE key  start  stop  --返回列表key中指定区间内的元素。列表元素从0开始。

LREM  key  n  value  --根据参数count的值，移除列表中所有与参数value相等的元素。

LSET  key  index  value  -- 将列表key中下标为index的元素的值设置为value

LTRIM key start stop  -- 保留列表key下标区间[start , stop ]的value。 不在这个区间的元素，全
部删除

LINDEX  key   index  -- 返回列表key中，下标为index的元素

LPOP/RPOP  key --移除并返回列表 表头/表尾 元素
```

<br/>

#### 3-6、HyperLogLog 基数统计。
每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 2^64 个不同元素的基 数。但是，因为 HyperLogLog 只会根据输入元素来计算基数，而不会储存输入元素本身，所以 HyperLogLog 不能像集合那样，返回输入的各个元素。

```
PFADD key element [element]  添加指定元素到 HyperLogLog 中。整型，如果至少有个元素被添加返回 1， 否则返回 0。

PFCOUNT key [key] 返回给定 HyperLogLog 的基数估算值。如果多个 HyperLogLog 则返回基数估值之和。

PFMERGE destkey sourcekey [sourcekey ...]  将多个 HyperLogLog 合并为一个 HyperLogLog
```

<br/>

#### 3-7、GEO 地理位置信息
比如说 附近的人 以及 摇一摇就是用这两个功能就可以用这个实现。

```
GEOADD key longitude latitude member [longitude latitude member ...] 将给定的空间元素（纬度、经度、名字）添加到指定的键里面。 这些数据会以有序集合的形式被储存在键里面， 从而使得像 
GEORADIUS 和 GEORADIUSBYMEMBER 这样的命令可以在之后通过位置查询取得这些元素。

GEOPOS key member [member ...]  从键里面返回所有给定位置元素的位置（经度和纬度）。

GEODIST key member1 member2 [m|km|ft|mi]  用来获取两个地理位置的距离
```
