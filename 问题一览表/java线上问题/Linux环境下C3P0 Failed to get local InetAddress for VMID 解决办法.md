## Linux环境下C3P0 Failed to get local InetAddress for VMID 解决办法

#### 问题
```
2019.07.29 19:24:18,804 +0800 [MLog-Init-Reporter] INFO  MLog - MLog clients using log4j logging.
2019.07.29 19:24:18,877 +0800 [main] INFO  UidUtils - Failed to get local InetAddress for VMID. This is unlikely to matter. At all. We'll add some extra randomness
java.net.UnknownHostException: d9528f35b965: d9528f35b965: Name does not resolve
        at java.net.InetAddress.getLocalHost(InetAddress.java:1505)
        at com.mchange.v2.uid.UidUtils.generateVmId(UidUtils.java:70)
        at com.mchange.v2.uid.UidUtils.<clinit>(UidUtils.java:54)
        at com.mchange.v2.c3p0.impl.C3P0ImplUtils.<clinit>(C3P0ImplUtils.java:126)
        at com.mchange.v2.c3p0.impl.PoolBackedDataSourceBase.<init>(PoolBackedDataSourceBase.java:288)
        at com.mchange.v2.c3p0.impl.AbstractPoolBackedDataSource.<init>(AbstractPoolBackedDataSource.java:74)
        at com.mchange.v2.c3p0.AbstractComboPooledDataSource.<init>(AbstractComboPooledDataSource.java:142)
        at com.mchange.v2.c3p0.AbstractComboPooledDataSource.<init>(AbstractComboPooledDataSource.java:138)
        at com.mchange.v2.c3p0.ComboPooledDataSource.<init>(ComboPooledDataSource.java:47)
        at play.db.DBPlugin.onApplicationStart(DBPlugin.java:137)
        at play.plugins.PluginCollection.onApplicationStart(PluginCollection.java:616)
        at play.Play.start(Play.java:541)
        at play.Play.init(Play.java:310)
        at play.server.Server.main(Server.java:160)
Caused by: java.net.UnknownHostException: d9528f35b965: Name does not resolve
        at java.net.Inet4AddressImpl.lookupAllHostAddr(Native Method)
        at java.net.InetAddress$2.lookupAllHostAddr(InetAddress.java:928)
        at java.net.InetAddress.getAddressesFromNameService(InetAddress.java:1323)
        at java.net.InetAddress.getLocalHost(InetAddress.java:1500)
        ... 13 more
```

<br/>

--

#### 问题原因。 d9528f35b965  怎么来的？
首先分析这个 d9528f35b965 是怎么来的，根据上下文错误来看，应该地址相关信息。紧接着，查看以下几个文件。

- hosts 文件
- network 文件
- hostname 文件

我是在 /etc/hostname 文件下看到了这个信息

所以可以分析是因为系统没有找到主机名w对应的IP，只需修改Linux的hosts文件即可。

<br/>

--

#### 解决方法
上面已经分析错误原因了，主要是因为系统没有找到主机名w对应的IP，修改Linux的hosts文件即可。具体操作步骤如下：
首先，执行 cat /etc/hosts 命令，如下：

```
[root@i-qt2zg63n conf]# vim /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 d9528f35b965
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
```

在第一行 127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 后加上 d9528f35b965 保存即可。

```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 d9528f35b965
```