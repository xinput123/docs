## 一、搭建 Kafka环境(下载kafka和Zookeeper)
### 1、修改Zookeeper配置文件。 config/zookeeper.properties。
```
tickTime=2000
initLimit=10
syncLimit=5
dataDir=F://log/zookeeper-log
clientPort=2181
maxClientCnxns=0
```

windows环境下，将 **zookeeper.properties**改名为 zoo.cfg。
修改完后，直接通过 **bin目录** 下 **zkServer.cmd**启动。

### 2、修改 Kafka 配置文件。config/server.properties,部分内容：
```
broker.id=0
port=9092
host.name=localhost
log.dirs=F://log/kafka-log-0
zookeeper.connect=localhost:2181
zookeeper.connection.timeout.ms=6000
```

### 3、启动 kafka server(kafka主目录下)
```
.\bin\windows\kafka-server-start.bat .\config\server.properties &
```

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-137ea38289d0b2bd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 3.1、创建Topic。在 kafka 的 /bin/windows目录下：

```
kafka-topics.bat --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
```

- 3.2、查看创建的Topic

```
kafka-topics.bat --list --zookeeper localhost:2181
```

- 3.3、启动控制台Producer，向Kafka发送消息

```
kafka-console-producer.bat --broker-list localhost:9092 --topic test
```

- 3.4、启动控制台Consumer，消费刚刚发送的消息，新开一个cmd。

```
kafka-console-consumer.bat --zookeeper localhost:2181 --topic test --from-beginning
```

- 3.4、删除Topic

```
kafka-topics.bat --delete --zookeeper localhost:2181 --topic test
注：只有当delete.topic.enable=true时，该操作才有效
```

### 4、配置kafka集群(单台机器)
- 4.1、拷贝 server.properties 多份(这里演示4个Kafka集群，因此再复制三个)。

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-6b4f00cacdaa130a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 4.2、修改相应的配置文件。

**server1.properties：**

```
broker.id=1
port=9093
log.dirs=F://log/kafka-log-1
```

**server2.properties：**

```
broker.id=2
port=9094
log.dirs=F://log/kafka-log-2
```

**server3.properties：**

```
broker.id=3
port=9095
log.dirs=F://log/kafka-log-3
```

- 4.3、启动这些节点，Kafka主目录下：

```	  
.\bin\windows\kafka-server-start.bat .\config\server1.properties &
.\bin\windows\kafka-server-start.bat .\config\server2.properties &
.\bin\windows\kafka-server-start.bat .\config\server3.properties &
```

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-821fcee773703e6a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 5、Topic & Partition
**Topic在逻辑上可以被认为是一个queue，每条消费都必须指定它的Topic**，可以简单理解为必须指明把这条消息放进哪个queue里。为了使得Kafka的吞吐率可以线性提高，**物理上把Topic分成一个或多个Partition，每个Partition在物理上对应一个文件夹，该文件夹下存储这个Partition的所有消息和索引文件**。

现在在Kafka集群上创建备份因子为3，分区数为4的Topic：

```
.\bin\windows\kafka-topics.bat --create --zookeeper localhost:2181 --replication-factor 3 --partitions 4 --topic kafka
```

***说明：备份因子replication-factor越大，则说明集群容错性越强，就是当集群down掉后，数据恢复的可能性越大。所有的分区数里的内容共同组成了一份数据，分区数partions越大，则该topic的消息就越分散，集群中的消息分布就越均匀。***

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-8fe5d3e78b0134b7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

然后使用kafka-topics.bat(kafka主目录下windows目录中)的--describe参数查看一下Topic为kafka的详情：

```
kafka-topics.bat --describe --zookeeper localhost:2181 --topic kafka
```

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-9138e4fc80bf5ba0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

输出的第一行是所有分区的概要，接下来的每一行是一个分区的描述。可以看到Topic为kafka的消息，PartionCount=4，ReplicationFactor=3正是我们创建时指定的分区数和备份因子。

另外：***Leader是指负责这个分区所有读写的节点；Replicas是指这个分区所在的所有节点（不论它是否活着）；ISR是Replicas的子集，代表存有这个分区信息而且当前活着的节点。***

拿partition:0这个分区来说，该分区的Leader是server0，分布在id为0，1，2这三个节点上，而且这三个节点都活着。

再看看 Kafka集群的日志：

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-d553df75b115714b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

其中kafka-logs-0代表server0的日志，kafka-logs-1代表server1的日志，以此类推。

从上面的配置可知，id为0，1，2，3的节点分别对应server0, server1, server2, server3。而上例中的partition:0分布在id为0, 1, 2这三个节点上，因此可以在server0, server1, server2这三个节点上看到有kafka-0这个文件夹。这个kafka-0就代表Topic为kafka的partion0。

## 二、Kafka + Log4j项目整合
### 1、Maven项目结构图

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-be9ebceccb6256e2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 2、pom.xml文件
```
<properties>
	<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
	<project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
	<java.version>1.8</java.version>
</properties>

<dependencies>
	<dependency>
		<groupId>org.apache.kafka</groupId>
		<artifactId>kafka_2.9.2</artifactId>
		<version>0.8.2.1</version>
	</dependency>
	<dependency>
		<groupId>org.apache.kafka</groupId>
		<artifactId>kafka-clients</artifactId>
		<version>0.8.2.1</version>
	</dependency>
	<dependency>
		<groupId>com.google.guava</groupId>
		<artifactId>guava</artifactId>
		<version>18.0</version>
	</dependency>
</dependencies>

<build>
	<plugins>
		<plugin>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-maven-plugin</artifactId>
		</plugin>
	</plugins>
</build>
```	

### 3、log4j.properties配置文件。
```
log4j.rootLogger=INFO,console

# for package com.demo.kafka, log would be sent to kafka appender.
log4j.logger.com.demo.kafka=DEBUG,kafka

# appender kafka
log4j.appender.kafka=kafka.producer.KafkaLog4jAppender
log4j.appender.kafka.topic=kafka
# multiple brokers are separated by comma ",".
log4j.appender.kafka.brokerList=localhost:9092, localhost:9093, localhost:9094, localhost:9095
log4j.appender.kafka.compressionType=none
log4j.appender.kafka.syncSend=true
log4j.appender.kafka.layout=org.apache.log4j.PatternLayout
log4j.appender.kafka.layout.ConversionPattern=%d [%-5p] [%t] - [%l] %m%n

# appender console
log4j.appender.console=org.apache.log4j.ConsoleAppender
log4j.appender.console.target=System.out
log4j.appender.console.layout=org.apache.log4j.PatternLayout
log4j.appender.console.layout.ConversionPattern=%d [%-5p] [%t] - [%l] %m%n
```	

### 4、App.java
```
package com.demo.kafka;

import org.apache.log4j.Logger;

public class App {
	private static final Logger LOGGER = Logger.getLogger(App.class);
	public static void main(String[] args) throws InterruptedException {
		String s = "02";
		LOGGER.debug(" debug app test " + s);
		LOGGER.info(" info app test " + s);
		LOGGER.warn(" warn app test " + s);
		LOGGER.error(" error app test " + s);
	}
}
```

### 5、MyConsumer.java用于消费kafka中的信息。
```
package com.demo.kafka;

import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import com.google.common.collect.ImmutableMap;
import kafka.consumer.Consumer;
import kafka.consumer.ConsumerConfig;
import kafka.consumer.KafkaStream;
import kafka.javaapi.consumer.ConsumerConnector;
import kafka.message.MessageAndMetadata;

public class MyConsumer {
	private static final String ZOOKEEPER = "localhost:2181";
	//groupName可以随意给，因为对于kafka里的每条消息，每个group都会完整的处理一遍
	private static final String GROUP_NAME = "test_group";
	private static final String TOPIC_NAME = "kafka";
	private static final int CONSUMER_NUM = 4;
	private static final int PARTITION_NUM = 4;

	public static void main(String[] args) {
		// specify some consumer properties
		Properties props = new Properties();
		props.put("zookeeper.connect", ZOOKEEPER);
		props.put("zookeeper.connectiontimeout.ms", "1000000");
		props.put("group.id", GROUP_NAME);

		// Create the connection to the cluster
		ConsumerConfig consumerConfig = new ConsumerConfig(props);
		ConsumerConnector consumerConnector =
				Consumer.createJavaConsumerConnector(consumerConfig);

		// create 4 partitions of the stream for topic “test”, to allow 4
		// threads to consume
		Map<String, List<KafkaStream<byte[], byte[]>>> topicMessageStreams =
				consumerConnector.createMessageStreams(
						ImmutableMap.of(TOPIC_NAME, PARTITION_NUM));
		List<KafkaStream<byte[], byte[]>> streams = topicMessageStreams.get(TOPIC_NAME);

		// create list of 4 threads to consume from each of the partitions
		ExecutorService executor = Executors.newFixedThreadPool(CONSUMER_NUM);

		// consume the messages in the threads
		for (final KafkaStream<byte[], byte[]> stream : streams) {
			executor.submit(new Runnable() {
				public void run() {
					for (MessageAndMetadata<byte[], byte[]> msgAndMetadata : stream) {
						// process message (msgAndMetadata.message())
						System.out.println(new String(msgAndMetadata.message()));
					}
				}
			});
		}
	}
}
```	

### 6、MyProducer.java用于向Kafka发送消息，但不通过log4j的appender发送。此案例中可以不要。
```
package com.demo.kafka;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import kafka.javaapi.producer.Producer;
import kafka.producer.KeyedMessage;
import kafka.producer.ProducerConfig;

/**
 * 发送消息到 kafka
 */
public class MyProducer {
	private static final String TOPIC = "kafka";
	private static final String CONTENT = "This is a single message";
	private static final String BROKER_LIST = "localhost:9092";
	private static final String SERIALIZER_CLASS = "kafka.serializer.StringEncoder";

	public static void main(String[] args) {
		Properties props = new Properties();
		props.put("serializer.class", SERIALIZER_CLASS);
		props.put("metadata.broker.list", BROKER_LIST);

		ProducerConfig config = new ProducerConfig(props);
		Producer<String, String> producer = new Producer<String, String>(config);

		//Send one message.
		KeyedMessage<String, String> message =
				new KeyedMessage<String, String>(TOPIC, CONTENT);
		producer.send(message);

		//Send multiple messages.
		List<KeyedMessage<String,String>> messages =
				new ArrayList<KeyedMessage<String, String>>();
		for (int i = 0; i < 5; i++) {
			messages.add(new KeyedMessage<String, String>
					(TOPIC, "Multiple message at a time. " + i));
		}
		producer.send(messages);
	}
}
```	

## 三、logstash从kafka中采集数据
### 1、 logstash 目录下创建 config1/ kafka.conf 文件。
```
input {     
	kafka {  
		bootstrap_servers => "127.0.0.1:9092"   #kafka集群地址，之前版本使用  zk_connect 
		group_id => "hdfs"
		topics => "kafka"  # 主题 。之前的版本使用 topic_id 
		codec => plain
		consumer_threads => 4
		decorate_events => true
		type => "kafka-input"   # 类型，默认好像是 log
	}
}
  
output {
	elasticsearch {
		hosts   => ["localhost:9200"]
	}
	stdout {    # stdout 在 logstash 中直接输出
		codec => rubydebug
	}
}
```

>注意：ELK版本 5.x 和之前版本有区别。

### 2、在logstash 主目录下，启动logstash。
```
logstash -f ..\config1\kafka.conf
```

## 四、运行和验证
先运行MyConsumer，使其处于监听状态。同时，还可以启动Kafka自带的ConsoleConsumer来验证是否跟MyConsumer的结果一致。最后运行App.java。

### 1、先来看看MyConsumer的输出

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-ba19bd1adfab2a57.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 2、ConsoleConsumer的输出。
```
kafka-console-consumer.bat --zookeeper localhost:2181 --topic kafka --from-beginning
```    

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-7ba86232733460d8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 3、最后再来看看Kafka的日志。可以看到，尽管发往Kafka的消息去往了不同的地方，但是内容是一样的，而且一条也不少。

>摘一点Infoq上的话：每个日志文件都是一个log entrie序列，每个log entrie包含一个4字节整型数值（值为N+5），1个字节的"magic value"，4个字节的CRC校验码，其后跟N个字节的消息体。每条消息都有一个当前Partition下唯一的64字节的offset，它指明了这条消息的起始位置。磁盘上存储的消息格式如下：

```
message length ： 4 bytes (value: 1+4+n)
"magic" value ： 1 byte 
crc ： 4 bytes 
payload ： n bytes
```

这里我们看到的日志文件的每一行，就是一个log entrie，每一行前面无法显示的字符（蓝色选中部分），就是（message length + magic value + crc）了。而log entrie的后部分，则是消息体的内容了。