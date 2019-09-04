## 一、mongo开启权限验证

### 1、linux中mongo开启权限验证
#### 1-1、增加管理员操作
```
-- 进入admin库
use admin 

-- 查看集合，包含system.user和system.version两个集合
show collections 

-- 查看是否有数据
db.system.users.find() 

-- 添加用户名，密码和权限
db.createUser({
  user:"admin",
  pwd:"admin",
  customData:{description:"管理员用户"},
  roles:[{role:"userAdminAnyDatabase",db:"admin"}] 
})
```

#### 1-2、找到mongo的配置文件，mongo.conf
```
auth=true    // 设置为 true
```

#### 1-3、重启mongo
```
service mongod stop
service mongod start
```

<br/>

### 2、docker中开启权限
```
-- 启动docker，并带上mongo --auth，即开启auth验证。
docker run --name mongo -d -p 27017:27017  --restart=always  mongo --auth  

-- 进入admin
docker exec -it mongo mongo admin 

-- 添加admin权限
db.createUser({ user: 'admin', pwd: 'admin', roles: [ { role: "root", db: "admin" } ] })  
```

<br/>

### 3、为每个mongo库创建read-write权限用户
```
-- 创建用户stats，密码2015Sts$!，权限 readWrite ，数据库 naruto。
use naruto; 
db.createUser({"user": "stats", "pwd": "2015Sts$!","roles": [{role: "readWrite",db: "naruto"}]})

-- 创建只读账号的用户
use test  
db.createUser({user: "zjyr",pwd: "zjyr",roles: [{ role: "read", db: "test" } ]})

-- 创建读写账号的用户
use test  
db.createUser({user: "zjy",pwd: "zjy",roles: [{ role: "readWrite", db: "test" }]}) 
```

<br/>

## 二、mongo状态查询命令
### 2-1、获取当前数据库的信息
```
> db.stats()
{
	"db" : "admin",  -- 库名
	"collections" : 6,    -- 集合数
	"objects" : 776,    -- 记录在数据库中所有文档总数
	"avgObjSize" : 540.6082474226804,    -- 数据库中所有文档的平均大小，等于dateSize / objects
	"dataSize" : 419512,    -- 数据库中所有文档的总大小，以字节为单位
	"storageSize" : 1118208,    -- 分配给每一个文档的磁盘空间
	"numExtents" : 7,    -- 事件数
	"indexes" : 5,    -- 索引数
	"indexSize" : 40880,    -- 索引大小
	"fileSize" : 67108864,    -- 文件大小
	"nsSizeMB" : 16,    -- 命名空间文件的大小
	"extentFreeList" : {
		"num" : 0,
		"totalSize" : 0
	},
	"dataFileVersion" : {    -- 包含 数据库文件的磁盘格式信息 的文档
		"major" : 4,    -- 主要版本号的 磁盘格式数据库的数据文件
		"minor" : 22    -- 次要版本号
	},
	"ok" : 1
}

> db.stats(1024) ; 得到的dataSize，storageSize是kb单位的。
> db.stats(1073741824); 得到的dataSize，storageSize是Gb单位的。
```

### 2-2、获取当前库中集合的信息
```
> db.person.stats()
/* 1 */
{
    "ns" : "demo.person",  # 命名空间
    "size" : 113,  # 大小
    "count" : 2,  # 记录数
    "avgObjSize" : 56, # 数据库中所有文档的平均大小
    "storageSize" : 45056,  # 分配给每一个文档的磁盘空间
    "capped" : false,
    "wiredTiger" : {
        "metadata" : {
            "formatVersion" : 1
        },
       .......
    "nindexes" : 1,
    "totalIndexSize" : 45056,
    "indexSizes" : {
        "_id_" : 45056
    },
    "ok" : 1.0
}
```

### 2-3、查看mongo上正在运行的命令,其实是mongo比较忙或者命令比较慢
```
> db.currentOp() 
-- 在没有负载的机器上，该命令基本上都是返回空的。如果你发现一个操作太长，把数据库卡死的话，可以用下面这个命令杀死他

> db.killOp("shard3:466404288")
```

### 2-4、基本状态信息 db.serverStatus()。这个命令下面有很多，我们可以继续精确查询一下。
#### 1、全局锁信息
```
> db.serverStatus().globalLock
{
	"totalTime" : NumberLong("3488145000"), --mongod启动后到现在的总时间，单位微秒
	"lockTime" :NumberLong(2031058), --mongod启动后全局锁锁住的总时间，单位微秒
	"currentQueue" : {
		"total" : 0,    -- 当前的全局锁等待锁等待的个数
		"readers" : 0,  -- 当前的全局读锁等待个数
		"writers" : 0   -- 当前全局写锁等待个数
	},
	"activeClients" : {
		"total" : 9,    -- 当前活跃客户端的个数
		"readers" : 0,  -- 当前活跃客户端中进行读操作的个数
		"writers" : 0   -- 当前活跃客户端中进行写操作的个数
	}
}
```
#### 2、内存信息
```
> db.serverStatus().mem
{
	"bits" : 64,      -- 操作系统位数
	"resident" : 79,  -- 物理内存消耗，单位M
	"virtual" : 580,  --虚拟内存消耗
	"supported" : true,  --为true表示支持显示额外的内存信息
	"mapped" : 240,   --映射内存
	"mappedWithJournal" : 480  --除了映射内存外还包括journal日志消耗的映射内存
}
```
#### 3、连接数信息
```
> db.serverStatus().connections
{ 
    "current" : 1,                  -- 当前连接数
	"available" : 838859,           -- 可用连接数
	"totalCreated" : NumberLong(1)  -- 截止目前为止总共创建的连接数
}
```
#### 4、索引统计信息
```
> db.serverStatus().indexCounters
{
	"accesses" : 35369670951, --索引访问次数，值越大表示你的索引总体而言建得越好，如果值增长很慢，表示系统建的索引有问题
	"hits" : 35369213426, --索引命中次数，值越大表示mogond越好地利用了索引
	"misses" : 0, --表示mongod试图使用索引时发现其不在内存的次数，越小越好
	"resets" : 0, --计数器重置的次数
	"missRatio" : 0 --丢失率，即misses除以hits的值
}
```
#### 5、后台刷新信息
```
> db.serverStatus().backgroundFlushing
{
	"flushes" : 67,   -- 数据库刷新写操作到磁盘的总次数，会逐渐增长
	"total_ms" : 26,  -- mongod写数据到磁盘消耗的总时间，单位ms，
	"average_ms" : 0.3880597014925373,  -- 上述两值的比例，表示每次写磁盘的平均时间
	"last_ms" : 0,  -- 当前最后一次写磁盘花去的时间，ms，结合上个平均值可观察到mongd总体写性能和当前写性能
	"last_finished" : ISODate("2017-09-27T06:44:46.304Z")  -- 最后一次写完成的时间
}
```
#### 6、操作计数器
```
> db.serverStatus().opcounters
{
	"insert" : 0,  -- mongod最近一次启动后的insert次数
	"query" : 1,   -- mongod最近一次启动后的query次数
	"update" : 0,  -- mongod最近一次启动后的update次数
	"delete" : 0,  -- mongod最近一次启动后的delete次数
	"getmore" : 0, -- mongod最近一次启动后的getmore次数,这个值可能会很高，因为子节点会发送getmore命令，作为数据复制操作的一部分
	"command" : 51 -- mongod最近一次启动后的执行command命令的次数
}
```

#### 7、记录状态信息
```
>db.serverStatus().recordStats
{
	"accessesNotInMemory" :4444249, -- 访问数据时发现不在内存的总次数
	"pageFaultExceptionsThrown" :22198, -- 由于页面错误而抛出异常的总次数
	"yc_driver" : {
		"accessesNotInMemory": 53441,
		"pageFaultExceptionsThrown": 18067
	},
	"yc_foot_print" : {
		"accessesNotInMemory": 0,
		"pageFaultExceptionsThrown": 0
}
```
#### 8、游标信息
```
> db.serverStatus().cursors
{
	"note" : "deprecated, use server status metrics",   //表示也可使用b.serverStatus().metrics.cursor命令看看
	"clientCursors_size" : 0,  // mongodb当前为客户端维护的游标个数
	"totalOpen" : 0,           // 和clientCursors_size一样
	"pinned" : 0,              // 打开的pinned类型的游标个数
	"totalNoTimeout" : 0,      // 设置了经过一段不活跃时间以后不设置超时，即参数“ DBQuery.Option.noTimeout”值以后，打开的游标个数
	"timedOut" : 0             // 从mongod启动以来的游标超时个数，如果这个值很大或者一直在增长，可能显示当前应用程序有错误
}
```
#### 9、metrics 命令也可以查询出一堆
```
db.serverStatus().metrics
```