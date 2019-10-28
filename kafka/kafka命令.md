## 创建一个分区数为4、副本因子为3的主体 topic-create
```
bin/kafka-topics.sh --zookeeper localhost:2181/kafka --create --topic topic-create --partitions 4 --replication-factor 2
```

