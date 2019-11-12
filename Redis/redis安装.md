# 一、Centos 7安装Redis
## 1、下载redis包
```
wget http://download.redis.io/releases/redis-4.0.6.tar.gz
```

## 2、解压redis包
```
tar -zxvf redis-4.0.6.tar.gz
```

## 3、yum安装gc依赖
```
yum install gcc -y
```

## 4、跳转到redis解压目录下
```
cd redis-4.0.6
```

## 5、编译安装
```
make MALLOC=libc　　

cd src

make install
```

## 6、以后台方式运行redis
#### 6-1、修改redis.conf文件
```
将 daemonize no 修改为 daemonize yes
```

#### 6-2、指定redis.conf文件启动
```
./redis-server /var/local/software/redis-4.0.6/redis.conf
```

#### 6-3、关闭redis进程
```
首先使用ps -aux | grep redis查看redis进程

 ps -aux | grep redis`
`root     18714  0.0  0.1 141752  2008 ?        Ssl  13:07   0:00 ./redis-server 127.0.0.1:6379`
`root     18719  0.0  0.0 112644   968 pts/0    R+   13:09   0:00 grep --color=auto redis`

使用kill命令杀死进程

kill -9 18714`
```

## 7、设置redis开机自启动
#### 7-1、在/etc目录下新建redis目录
```
cd /etc

mkdir redis
```

#### 7-2、将/usr/local/redis-4.0.6/redis.conf 文件复制一份到/etc/redis目录下，并命名为6379.conf
```
cp /var/local/software/redis-4.0.6/redis.conf /etc/redis/6379.conf`
```

#### 7-3、
```
cp /var/local/software/redis-4.0.6/utils/redis_init_script /etc/init.d/redisd
```

#### 7-4、
```
cd /etc/init.d

chkconfig redisd on`

service redisd does not support chkconfig

看结果是redisd不支持chkconfig
解决方法：
使用vim编辑redisd文件，在第一行加入如下两行注释，保存退出
# chkconfig:   2345 90 10`
# description:  Redis is a persistent key-value database`
注释的意思是，redis服务必须在运行级2，3，4，5下被启动或关闭，启动的优先级是90，关闭的优先级是10。

再次执行开机自启命令，成功
chkconfig redisd on

现在可以直接已服务的形式启动和关闭redis了
service redisd start　

如果出现如下问题：
service redisd start
/var/run/redis_6379.pid exists, process is already running or crashed
引起这类问题一般都是强制关掉电源或断电造成的，也是没等linux正常关机

```