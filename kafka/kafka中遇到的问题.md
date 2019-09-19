### kafka无法创建topic
#### 1、有问题原始命令
```
-- 创建一个分区为1，副本因子为1的主体，topic-demo
bin/kafka-topics.sh --create --zookeeper localhost:2181--replication-factor 1 --partitions 1 --topic topic-demo
```

#### 2、服务器出现的提示
```
Error while executing topic command : Replication factor: 1 larger than available brokers: 0.

ERROR org.apache.kafka.common.errors.InvalidReplicationFactorException: Replication factor: 1 larger than available brokers: 0.
```

#### 3、这个可能是创建topic时Zookeeper的路径不正确造成的。因为我的kafka的配置文件config/server.properties中的zookeeper.connect的值是
```
zookeeper.connect=localhost:2181/kafka
```

#### 4、所以这个问题的原因是kafka创建的节点不一致，所以因为用如下命令即可
```
bin/kafka-topics.sh --create --zookeeper localhost:2181/kafka --replication-factor 1 --partitions 1 --topic topic-demo
```