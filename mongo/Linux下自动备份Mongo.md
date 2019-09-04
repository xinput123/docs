## 一、Linux下自动备份Mongodb数据库并删除指定天数前的备份
#### 1、创建Mongodb数据库备份目录
```
mkdir -p /home/backup/mongod_bak/mongod_bak_now

mkdir -p /home/backup/mongod_bak/mongod_bak_list
```

#### 2、新建Mongodb数据库备份脚本
##### 新建文件/home/crontab/mongod_bak.sh，输入以下代码
```
#!/bin/sh
# mongodump备份文件执行路径
DUMP=/usr/local/mongodb/bin/mongodump 
#临时备份目录
OUT_DIR=/home/backup/mongod_bak/mongod_bak_now 
#备份存放路径
TAR_DIR=/home/backup/mongod_bak/mongod_bak_list 
#获取当前系统时间
DATE=`date +%Y_%m_%d` 
#数据库账号
DB_USER=username
#数据库密码
DB_PASS=123456 
#DAYS=7代表删除7天前的备份，即只保留最近7天的备份
DAYS=7 
#最终保存的数据库备份文件名
TAR_BAK="mongod_bak_$DATE.tar.gz" 
cd $OUT_DIR
rm -rf $OUT_DIR/*
mkdir -p $OUT_DIR/$DATE
#备份全部数据库
$DUMP -u $DB_USER -p $DB_PASS -o $OUT_DIR/$DATE 
#压缩为.tar.gz格式
tar -zcvf $TAR_DIR/$TAR_BAK $OUT_DIR/$DATE 
#删除7天前的备份文件
find $TAR_DIR/ -mtime +$DAYS -delete 
:wq! #保存退出
```

#### 3、修改文件属性，使其可执行
```
chmod +x /home/crontab/mongod_bak.sh
```

#### 4、修改/etc/crontab #添加计划任务
vi /etc/crontab #在下面添加
```
#表示每天凌晨1点30执行备份
30 1 * * * root /home/crontab/mongod_bak.sh 
```

#### 5、重新启动crond使设置生效
```
/etc/rc.d/init.d/crond restart

#设为开机启动
chkconfig crond on 

#启动
service crond start 
```
每天在/home/backup/mongod_bak/mongod_bak_list目录下面可以看到mongod_bak_2015_02_28.tar.gz这样的压缩文件。
至此，Linux下自动备份Mongodb数据库并删除指定天数前的备份完成。

#### 6、附录：Mongodb数据库恢复
#### 6-1、恢复全部数据库：
```
mongorestore --drop --directoryperdb  /home/backup/mongod_bak/mongod_bak_now/2015_02_28/
```

#### 6-2、恢复单个数据库：
```
mongorestore --drop -d dataname --directoryperdb /home/backup/mongod_bak/mongod_bak_now/2015_02_28/dataname
```
- --drop参数：恢复数据之前删除原来数据库数据，避免数据重复。
- --directoryperdb参数：数据库备份目录
- -d参数：后面跟要恢复的数据库名称
