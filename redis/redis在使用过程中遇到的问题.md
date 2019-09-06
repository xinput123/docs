## 一、异常：
```
redis.clients.jedis.exceptions.JedisDataException: LOADING Redis is loading the dataset in memory
```

#### 1、异常描述
redis中dump.rdb文件到达3G时，所有redis的操作都会抛出此异常。

#### 2、解决方法，修改redis配置文件：
```
 maxmemory <5368709120> 
```
设置大一些，比如5G，30G等。

