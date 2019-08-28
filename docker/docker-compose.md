## 一、docker-compose.yml文件
```
version: '2'
services:
  mysql:
    image: mysql:5.7
    container_name: mysql
    restart: always
    environment:
      - TZ=Asia/Shanghai # 设置时区
      - MYSQL_ROOT_PASSWORD=123456
    ports:
     - "3306:3306"
    volumes:
      - /etc/localtime:/etc/localtime
    command: --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
  api:
    image: api
    container_name: api
    restart: always
    volumes:
      - /logs/dpcp-sync-data/api/log:/app/log
    ports:
      - "9999:9999"
```

<br/>

## 二、docker-compose命令
```
docker-compose up  -d 启动compose中所有容器

docker-compose up  -d api  启动compose中的api容器

docker-compose down  移除所有容器

docker-compose restart 重启compose中所有容器

docker-compose restart api  重启compose中api容器
```

<br/>

## 三、docker-compose.yml
```
# tomcat版
demo-websocket-tomcat:
  # 指定用于构建镜像的Dockerfile路径, 值为字符串
  build: '.'
  # 设置容器用户名(镜像中已创建)，默认root
  user: user_docker
  # 设置容器主机名
  hostname: docker-anyesu
  # 容器内root账户是否拥有宿主机root账户的所有权限 [参考](http://blog.csdn.net/halcyonbaby/article/details/43499409)
  privileged: false
  # always (当容器退出时docker自动重启它)
  # on-failure:10 (当容器非正常退出, 最多自动重启10次, 10之后不再重启)
  restart: always
  # 容器的网络连接类型,anyesu_net是创建的自定义网桥
  net: anyesu_net
  # 挂载点，设置与宿主机之间的路径映射
  volumes:
  - /usr/anyesu/docker/tomcat-logs:/usr/anyesu/tomcat/logs
  # :ro表示只读,默认为:rw
  #- /usr/anyesu/docker/tomcat-logs:/usr/anyesu/tomcat/logs:ro
  # 与宿主机之间的端口映射
  ports:
  - 8080:8080
  # 设置容器dns, 如果设置了net项则此项失效, 暂不清楚原因, 不过可以使用本地文件映射为容器的/etc/resolv.conf文件。
  dns: 8.8.8.8
  # 设置容器环境变量
  environment:
    JAVA_OPTS: -Djava.security.egd=file:/dev/./urandom
```