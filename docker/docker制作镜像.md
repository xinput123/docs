#### 1、在docker中运行war包
![4046640-c25a6faafa5ede61.png](https://upload-images.jianshu.io/upload_images/4046640-2120c9f851b1b29a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 1、 新建一个文件夹 D:/download/docker/order
- 2、将order.war放入到文件夹D:/download/docker/order中；
- 3、从tomcat的conf文件夹中拷贝一份server.xml文件到D:/download/docker/order目录下，并将server.xml文件中的部分内容替换成，替换的是<Host>标签的内容

```
<Host name="localhost"  appBase="webapps" unpackWARs="true" autoDeploy="true">
    <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
        prefix="localhost_access_log" suffix=".txt"
        pattern="%h %l %u %t "%r" %s %b" />
    <Context path="" docBase="order" debug="0" reloadable="true"/>
</Host>
```

- 4、在D:/download/docker/order中新建一个Dockerfile文件，去掉后缀名。Dockerfile中的内容如下：

```
# FROM 指令告诉 Docker 使用哪个镜像作为基础
FROM tomcat:jre8-tomcat8-alpine   
RUN rm -rf /app/conf/server.xml
ADD server.xml /app/conf/
ADD order.war /app/webapps/
```

- 5、打开docker，进入到D:/download/docker/order目录下，创建镜像
```
docker build -t order:1.0 . 
```
>- 6、docker run -d -p 80:8080 order:1.0

<br/>

#### 2、在docker中运行jar包
![4046640-7595b71d7af91d6d.png](https://upload-images.jianshu.io/upload_images/4046640-804e742b84495168.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 1、 新建一个文件夹 D:/download/docker/mq
- 2、 将receipt.war放入到文件夹D:/download/docker/mq中；
- 3、 在D:/download/docker/receipt中新建一个Dockerfile文件，去掉后缀名。Dockerfile中的内容如下：

```
FROM java:8u77-jre-alpine
VOLUME /tmp
ADD api-mq.jar app.jar
RUN sh -c 'touch /app.jar'
ENTRYPOINT ["java","-    Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```

- 4、打开docker，进入到D:/download/docker/mq目录下，创建镜像

```
docker build -t mq:1.0 . 
```

- 5、docker run -d -p 80:8080 mq:1.0

#### 3、将jar包打成一个镜像
编写dockfile文件

```
# 基于镜像  镜像名称:tag号
FROM java:8u92-jre-alpine

# 将本地文件夹挂载到当前容器
VOLUME /tmp

# 拷贝文件到容器
ADD EurekaServer.jar app.jar
RUN sh -c 'touch /app.jar'

# 开放端口
EXPOSE 9999

# 配置容器启动后执行的命令
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```

或者把文件丢到指定目录，而不是根目录下

```
# 基于镜像  镜像名称:tag号
FROM java:8u92-jre-alpine

# 将本地文件夹挂载到当前容器
VOLUME /tmp

# 拷贝文件到容器
ADD EurekaServer.jar /app/app.jar
RUN sh -c 'touch /app/app.jar'

# 开放端口
EXPOSE 9999

# 配置容器启动后执行的命令
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app/app.jar"]
```