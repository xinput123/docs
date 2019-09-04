## 一、mongodump/mongostore 和 mongoexport/mongoimport 区别
官方文档有描述[mongo](https://docs.mongodb.com/manual/reference/program/mongoimport/#considerations) 有以下几点

- 1、避免使用mongoimport和mongoexport进行完整的实例生成备份。
- - 因为mongoimport,mongoexport只是导入导出JSON格式数据
- - 无法支持和保留所有的类型的数据
- 2、MongoDB备份使用mongodump和mongostore


## 二、导出 — mongodump
```
mongodump -h IP地址 -p 端口 -u 用户名 -p 密码 --authenticationDatabase 认证数据库名称 -d yy -c person -q '{x:3}' -o /xinput

mongodump -h 127.0.0.1 -p 27017 -u admin -p admin --authenticationDatabase admin -d yy -c person -q '{x:3}' -o /xinput
```

- **-h** 要导出的mongo所在的主机ip地址，如果是本机，可以去掉 -h
- **-p** mongo开启的端口号，如果是默认27017，可以去掉 -p
- **-u** 用户名，没有用户可以去掉-u和-p
- **-p** 密码
- **--authenticationDatabase** 指定的是验证用户名和密码的数据库
- **-d** 目标数据库
- **-c** 目标集合
- **-q** 条件
- **-o** 导出文件路径

<br/>

## 三、还原 — mongorestore
```
mongorestore -h IP --port port -u 用户名 -p 密码 --authenticationDatabase 认证数据库名 -d 数据库 -c 集合 --drop /xinput/yy/person.bson  

mongorestore -h 127.0.0.1 --port 27017 -u admin -p admin  --authenticationDatabase admin -d yy -c person --drop /xinput/yy/person.bson
```

- **-h** 要导出的mongo所在的主机ip地址，如果是本机，可以去掉 -h
- **-p** mongo开启的端口号，如果是默认27017，可以去掉 -p
- **-u** 用户名，没有用户可以去掉-u和-p
- **-p** 密码
- **--authenticationDatabase** 指定的是验证用户名和密码的数据库
- **-d** 目标数据库
- **-c** 目标集合
- **-o** 导出文件路径


## 四、复制数据库
```
db.copyDatabase(fromdb,todb,fromhost,username,password,mechanism)
```
- 1、fromdb：源db的名称；
- 2、todb：目标db的名称；
- 3、fromhost：源db的主机地址，如果在同一个mongod实例内可以省略；
- 4、username: 如果开启了验证模式，需要源DB主机上的MongoDB实例的用户名；
- 5、password: 同上，需要对应用户的密码；
- 6、mechanism: fromhost验证username和password的机制，有：MONGODB-CR、SCRAM-SHA-1两种。

**db.copyDatabase("docker_demo","docker_dev")**  在同一个mongo实例下，复制一个数据库的数据到另外一个数据库。

#### 2、mongo中快速备份一张表的数据。
```
db.test（复制源表）.find().forEach(function(x){
	db.target（目的表）.insert(x);
})
```
> 利用foreach方法在shell里直接运行。    

