## 一、Kafka中概念
#### 1、Producer 生产者
发送消息的一方。生产者负责创建消息，然后将其投递的kafka中。

#### 2、Consumer 消费者
接受消息的一方。消费者连接到kafka上并接收消息，进而进行相应的业务逻辑处理。

#### 3、Broker 服务代理节点
对于Kafka来说，Broker可以简单地看作一个独立的Kafka服务节点或Kafka服务实例。

#### 4、Topic 主题 和 Partition 分区
Kafka中的消息以主题为单位进行归纳，生产者负责将消息发送到特定的主体，即每条消息都要指定一个主题，消费者负责订阅主题进行消费。

一个主题可以有多个分区，一个分区只能属于一个主题。


<br/>
## 二、$KAFKA_HOME/config/server.properties 文件
#### 1、zookeeper.connect
该参数指明broker要连接的Zookeeper集群的服务地址，包括端口号。可以是多个，多个之间用逗号分割 hostname1:port1,hostname2:port2,hostname3:port3

```
zookeeper.connect = localhost:2181
```

#### 2、listeners
指定broker监听客户端连接的地址列表，配置私网IP供broker间通信使用。配置格式为  protocol1://hostname1:port1,protocol2://hostname2:port2, 其中，protocol代表协议类型，Kafka当前支持的协议类型有 **PLAINTEXT、SSL、SASL、SASL_SSL**等，

#### 3、advertised.listeners 
绑定外网IP供外部客户端使用