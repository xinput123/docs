### Zookeeper的配置项在zoo.cfg配置文件中，3个最重要的配置项
- clientPort ：Zookeeper对客户端提供服务的端口。
- dataDir ：用来保存快照文件的目录。如果没有设置 dataLogDir，事务日志文件也会保存到这个目录
- dataLogDir ：用来保存事务日志文件的目录。因为Zookeeper在提交一个事务之前，需要保证事务日志记录的落盘，所以需要为dataLogDir分配一个单独的存储设置。

### Zookeeper节点硬件要求
- 内存 ： Zookeeper需要在内存中保存 data tree。对于一般的Zookeeper应用场景，8G的内存足够。
- CPU ： Zookeeper对CPU消耗不高。只要保证Zookeeper能有有一个独占的CPU即可。所以使用一个双核的CPU。
- 存储 ：因为存储设备的写延迟会直接影响事务提交的效率，建议为dataLogDir分配一个独占的SSD盘。 

### Zookeeper安装配置步骤
- 1、申请Zookeeper节点服务器，每个Zookeeper节点有两个挂载盘
- 2、每个节点安装JDK8
- 3、在每个节点为dataLogDir初始化一个独立的文件系统 /data,编辑 /data/zookeeper/myid
- 4、各个节点之间配置基于 public key 的ssh登录
- 5、在一个节点上下载解压 apache-zookeeper-3.5.5-bin.tar.gz，配置zoo.cfg。使用rsync把解压的目录同步到其他节点。
