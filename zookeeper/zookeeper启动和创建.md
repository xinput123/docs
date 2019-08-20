## 一、Zookeeper下载
[Zookeeper官网](https://zookeeper.apache.org/) -> Download -> Download -> archive.

进入 [归档页面](https://archive.apache.org/dist/zookeeper/)，选择 stable 下载。

## 二、安装
Zookeeper下载后，直接解压即可

## 三、配置Zookeeper的环境变量
```
# export zk
export ZOOKEEPER_HOME=$HOME/soft/apache-zookeeper-3.5.5-bin
export ZOOBINDIR=$ZOOKEEPER_HOME/bin
export PATH=$ZOOBINDIR:$PATH
```

## 四、启动
```
## 启动Zookeeper
zkServer.sh start

## 启动后会在logs下产生一个日志文件 zookeeper-yuanlai-server-yuanlaideMBP.lan.out
cd logs
ls

## 观察日志文件是否有错，如果为空，表示无异常
grep -E -i "((exception)|(error))" *
```

## 五、启动 zkCli.sh,进入后，可以通过查看 help看看支持哪些命令
```
zkCli.sh

## 查看当前有哪些znode, -R 表示递归的向下寻找，默认Zookeeper会有/zookeeper的znode
ls -R /

## 创建 znode
create /app2
create /app1
create /app1/p_1
create /app1/p_2
create /app1/p_3
```

## 六、实现一个锁
```
## 在客户端1中，创建临时znode， -e 表示临时znode，表示加锁
create -e /lock

## 在客户端2中，创建临时znode， -e 表示临时znode，表示加锁，会失败,因为已经存在
create -e /lock

## 在客户端2中，监控锁
stat -w /lock

## 客户端1退出，会在客户端2中收到一个watch事件
quit

## 客户端2收到watch事件后，再尝试加锁，即可成功
create -e /lock
```