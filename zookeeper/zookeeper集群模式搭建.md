## 搭建3节点quorum模式Zookeeper

#### zoo-quorum-node1.cfg
```
tickTime=2000

initLimit=10

syncLimit=5

dataDir=/data/zk/quorum/node1

clientPort=2181

server.1=127.0.0.1:3333:3334
server.2=127.0.0.1:4444:4445
server.3=127.0.0.1:5555:5556
```

#### zoo-quorum-node2.cfg
```
tickTime=2000

initLimit=10

syncLimit=5

dataDir=/data/zk/quorum/node2

clientPort=2182

server.1=127.0.0.1:3333:3334
server.2=127.0.0.1:4444:4445
server.3=127.0.0.1:5555:5556
```

#### zoo-quorum-node3.cfg
```
tickTime=2000

initLimit=10

syncLimit=5

dataDir=/data/zk/quorum/node3

clientPort=2183

server.1=127.0.0.1:3333:3334
server.2=127.0.0.1:4444:4445
server.3=127.0.0.1:5555:5556
```

### 配置说明
3个配置文件的server.n 部分是一样的。

server.1=127.0.0.1:3333:3334 中，3333表示用于 quorum 通信的端口，3334是用于选举leader的端口

#### 为每个节点创建 myid 文件，里面存放的分别是 server.n 的值
myid 文件的位置是 dataDir 所指的位置，对应三个文件分别位于

- /data/zk/quorum/node1/myid  myid中的值为1
- /data/zk/quorum/node2/myid  myid中的值为2
- /data/zk/quorum/node3/myid  myid中的值为3

#### 启动
```
zkServer.sh start-foreground /Users/yuanlai/soft/apache-zookeeper-3.5.5-bin/conf/zoo-quorum-node1.cfg

zkServer.sh start-foreground /Users/yuanlai/soft/apache-zookeeper-3.5.5-bin/conf/zoo-quorum-node2.cfg

zkServer.sh start-foreground /Users/yuanlai/soft/apache-zookeeper-3.5.5-bin/conf/zoo-quorum-node3.cfg
```
- start-foreground 选项是把日志直接打到console中，本地测试需要，生产环境不需要加这个参数