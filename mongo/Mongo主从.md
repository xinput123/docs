## 一、主从配置
假设现在有两台mongo服务器 27和28，这里27当做主库，28作为从库。

#### 1、主库配置 27. mongodb.conf
```
#where to log
logpath=/var/log/mongodb/mongod.log

logappend=true

# fork and run in background
fork=true

port=27017

dbpath=/home/mongodb/db

# location of pidfile
pidfilepath=/var/run/mongodb/mongod.pid

profile=2

maxConns=10000
master=true

source=192.168.1.28    #这里指向的是从库

auth=true

#主从开启auth验证，需要通过keyfile来建立验证关系
keyFile=/usr/local/mongodb/keyFile/mongo-keyfile

# Listen to local interface only. Comment out to listen on all interfaces. 
#bind_ip=127.0.0.1,45.79.206.82
#bind_ip=192.168.1.25

#master=true
#source=192.168.172.95

# Disables write-ahead journaling
# nojournal=true

# Enables periodic logging of CPU utilization and I/O wait
#cpu=true

# Turn on/off security.  Off is currently the default
#noauth=true
#auth=true

# Verbose logging output.
#verbose=true

# Inspect all client data for validity on receipt (useful for
# developing drivers)
#objcheck=true

# Enable db quota management
#quota=true

# Set oplogging level where n is
#   0=off (default)
#   1=W
#   2=R
#   3=both
#   7=W+some reads
#diaglog=0

# Ignore query hints
#nohints=true

# Enable the HTTP interface (Defaults to port 28017).
#httpinterface=true

# Turns off server-side scripting.  This will result in greatly limited
# functionality
#noscripting=true

# Turns off table scans.  Any query that would do a table scan fails.
#notablescan=true

# Disable data file preallocation.
#noprealloc=true

# Specify .ns file size for new databases.
# nssize=<size>

# Replication Options

# in replicated mongo databases, specify the replica set name here
#replSet=setname
# maximum size in megabytes for replication operation log
#oplogSize=1024
# path to a key file storing authentication info for connections
# between replica set members
#keyFile=/path/to/keyfile
```

<br/>

#### 2、从库配置 28. mongodb.conf
```
#where to log
logpath=/var/log/mongodb/mongod.log

logappend=true

# fork and run in background
fork=true

port=27017

dbpath=/home/mongodb/db

# location of pidfile
pidfilepath=/var/run/mongodb/mongod.pid

profile=2

#maxConns=10000
maxConns=20000


slave=true  #表示是从库
source=192.168.1.27  #指明主库的地址

auth=true

keyFile=/usr/local/mongodb/keyFile/mongo-keyfile

# Listen to local interface only. Comment out to listen on all interfaces. 
#bind_ip=127.0.0.1,45.79.193.83
#bind_ip=192.168.1.25

#slave=true
#source=192.168.134.191 

# Disables write-ahead journaling
# nojournal=true

# Enables periodic logging of CPU utilization and I/O wait
#cpu=true

# Turn on/off security.  Off is currently the default
#noauth=true
#auth=true

# Verbose logging output.
#verbose=true

# Inspect all client data for validity on receipt (useful for
# developing drivers)
#objcheck=true

# Enable db quota management
#quota=true

# Set oplogging level where n is
#   0=off (default)
#   1=W
#   2=R
#   3=both
#   7=W+some reads
#diaglog=0

# Ignore query hints
#nohints=true

# Enable the HTTP interface (Defaults to port 28017).
#httpinterface=true

# Turns off server-side scripting.  This will result in greatly limited
# functionality
#noscripting=true

# Turns off table scans.  Any query that would do a table scan fails.
#notablescan=true

# Disable data file preallocation.
#noprealloc=true

# Specify .ns file size for new databases.
# nssize=<size>

# Replication Options

# in replicated mongo databases, specify the replica set name here
#replSet=setname
# maximum size in megabytes for replication operation log
#oplogSize=1024
# path to a key file storing authentication info for connections
# between replica set members
#keyFile=/path/to/keyfile
```

#### 3、Linux中如何启动MongoDB？
如果服务器中已经有mongo启动了，可以通过ps -ef | grep mongo去查看启动mongo的命令，并查看端口，然后使用 kill  -2  端口号，杀掉进程。

```
// 启动mongo。
mongod --config /usr/local/mongodb/conf/mongodb.conf  
```
启动之后，查看/var/log/mongodb/mongod.log这个日志。mongodb.conf是数据库的配置文件。


## 二、主从库状态查询
#### 1、查看当前库是否是主库
```
db.isMaster()

db.runCommand({"isMaster":1})
```

#### 2、查看副本集成员数据同步情况
```
rs.printReplicationInfo()

db.printSlaveReplicationInfo();   #最好在secondary上执行

rs.printReplicationInfo()

rs.printSlaveReplicationInfo()

use local>db.slaves.find()
```

#### 3、进入从库操作
```
rs.slaveOk()
```
