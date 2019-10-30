## 一、通过robo 3t 连接docker启动的mongo数据库。Network error while attempting to run command 'saslStart'
使用客户端连接远程vps服务器上的mongodb数据库时报错，ssh连接上去可以使用mongo连接，也可以使用
mongo -u admin -p passward --authenticationDatabase dbname 连接，配置文件中的ip绑定的是 0.0.0.0没问题，防火墙已经关闭了，但是在本地客户端

![mongo连接异常](https://github.com/xinput123/docs/blob/master/%E5%9B%BE%E7%89%87/mongo%E8%BF%9E%E6%8E%A5%E9%97%AE%E9%A2%98.jpg)

#### 原因
通过查看日志，发现是缺少 saslstart 相关的一些依赖，导致加密和解密过程出现问题。将mongo版本切换到4.0.10即可，其他版本没有测试，本人用的是4.2.0版本