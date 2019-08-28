## 一、docker容器和宿主机相互拷贝文件
##### 1、docker容器拷贝文件到宿主机
```
sudo docker cp <containerId>:/file/path/within/container /host/path/target
```
>- containerId 是docker容器id。
>
>- /file/path/within/container 是文件container 的绝对路径。
>
>- /host/path/target 将文件拷贝到该路径下。

示例：

```
// 移动容器id是3bd的 /home/activemqLog 路径下的api_mqLog201678.txt 到 宿主机/home/docker/下。
docker@default:~$ docker cp 3bd:/home/activemqLog/api_mqLog201678.txt /home/docker/ 
```

#### 2、宿主机拷贝文件到容器
宿主机机中执行 docker cp 要拷贝的文件路径 容器名：要拷贝到容器里面对应的路径

```
docker cp /opt/test.js mongo:/usr/local/tomcat/webapps/test/js
```

## 二、在宿主机查看docker使用cpu、内存、网络、io情况
>-  docker stats 容器名
>
>-  docker stats 容器id。都是动态显示数据

![image.png](http://upload-images.jianshu.io/upload_images/4046640-998587b3da68b2a6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**说明**
>- **memory.usage_in_bytes**	已使用的内存量(包含cache和buffer)(字节)，相当于linux的used_meme
>
>- **memory.limit_in_bytes**	限制的内存总量(字节)，相当于linux的total_mem
>
>- **memory.failcnt**	申请内存失败次数计数
>
>- **memory.memsw.usage_in_bytes**	已使用的内存和swap(字节)
>
>- **memory.memsw.limit_in_bytes**	限制的内存和swap容量(字节)
>
>- **memory.memsw.failcnt**	申请内存和swap失败次数计数
>
>- **memory.stat**	内存相关状态