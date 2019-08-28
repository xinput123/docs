## 一、普通运行docker命令
```
docker run -d -p 3308:3306 -e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_DATABASE=my_db mysql:5.7
```

- **MYSQL_ROOT_PASSWORD=123456**  指定 root 用户名密码 123456
- **MYSQL_DATABASE=my_db** 创建数据库实例 my_db

<br/>

***有的时候，我们需要在创建容器的时候初始化我们的sql脚本，mysql的官方镜像可以支持在容器启动的时候自动执行指定的sql脚本或者shell脚本***

[Mysql官方镜像的Dockerfile](https://github.com/docker-library/mysql)，下图是部分内容：

```
COPY docker-entrypoint.sh /usr/local/bin/

RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306 33060

CMD ["mysqld"]
```

已经设定了ENTRYPOINT，里面会调用/entrypoint.sh这个脚本，脚本其中一段内容如下:

```
process_init_file() {
	local f="$1"; shift
	local mysql=( "$@" )

	case "$f" in
		*.sh)     echo "$0: running $f"; . "$f" ;;
		*.sql)    echo "$0: running $f"; "${mysql[@]}" < "$f"; echo ;;
		*.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${mysql[@]}"; echo ;;
		*)        echo "$0: ignoring $f" ;;
	esac
	echo
}
```
**遍历docker-entrypoint-initdb.d目录下所有的.sh和.sql后缀的文件并执行。**

<br/>

## 二、创建实例并初始化sql脚本
**将数据库初始化脚本拷贝到docker-entrypoint-initdb.d 目录下，编写Dockerfile 文件**

### 2-1、DockerFile文件
```
#基础镜像使用 mysql:latest
FROM mysql:latest

#定义会被容器自动执行的目录
ENV AUTO_RUN_DIR /docker-entrypoint-initdb.d

#定义初始化sql文件
ENV INSTALL_DB_SQL init.sql

#把要执行的sql文件放到/docker-entrypoint-initdb.d/目录下，容器会自动执行这个sql
COPY ./$INSTALL_DB_SQL $AUTO_RUN_DIR/

#给执行文件增加可执行权限
RUN chmod a+x $AUTO_RUN_DIR/$INSTALL_DB_SQL
```

<br/>

### 2-2、init.sql
```
-- 建库
CREATE DATABASE IF NOT EXISTS my_db default charset utf8 COLLATE utf8_general_ci;

-- 切换数据库
use my_db;

-- 设置字符编码，创建表的语句
set character_set_client=utf8mb4;

-- 设置字符编码，插入数据的编码
set character_set_connection=utf8mb4;

DROP TABLE IF EXISTS `t_doctor`;

CREATE TABLE `t_doctor` (
  `id` varchar(255) NOT NULL DEFAULT '',
  `hospital_id` varchar(255) DEFAULT NULL COMMENT '医院id',
  `name` varchar(255) DEFAULT NULL COMMENT '医务人员姓名',
  `username` varchar(255) DEFAULT NULL COMMENT '登录用户名',
  `password` varchar(255) DEFAULT NULL COMMENT '登录密码',
  `phone` varchar(11) DEFAULT NULL COMMENT '手机号',
  `department` varchar(55) DEFAULT NULL COMMENT '所在科室名称',
  `title` varchar(255) DEFAULT NULL COMMENT '医务人员职称',
  `duty` varchar(255) DEFAULT NULL COMMENT '职责',
  `consult_type` varchar(20) DEFAULT NULL COMMENT '新咨询类型',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像相对路径',
  `role_name` varchar(255) DEFAULT NULL COMMENT '角色名',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `record_state` tinyint(1) DEFAULT NULL COMMENT '记录有效标识 0有效 1无效',
  `disable` tinyint(1) DEFAULT '0' COMMENT '是否禁用 1是 0否',
  `ref_key` varchar(32) DEFAULT NULL COMMENT '外部关联数据key（医院医生编号）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='医护人员';

LOCK TABLES `t_doctor` WRITE;

INSERT INTO `t_doctor` (`id`, `hospital_id`, `name`, `username`, `password`, `phone`, `department`, `title`, `duty`, `consult_type`, `avatar`, `role_name`, `create_time`, `update_time`, `record_state`, `disable`, `ref_key`)
VALUES
	('5acd8ca2d487e1c16c6f5adc','5acd8b68d487e1be9eb5f8aa','咨询护士','zixun','$2a$10$C41saRPlPvjYr1U9oVGFHeXWF19X4ORlfVJM0hGyGZXC/UOxmioGe','18888888888','诊前',NULL,'consult',NULL,'/v1/files/2ed1b5dca4774a6d845468f37962ecec.jpg','5','2018-04-11 12:18:42','2018-10-29 20:10:41',0,0,NULL),
	('5b0393737b75903a27b4868a','5acd8b68d487e1be9eb5f8aa','卢光琇','1','$2a$10$iECkSdWhlMaBZoqJ3Jt8tuhBooBXbEC2eD9m.mADt24NRiYDQvrXW','','0001','医生','clinic',NULL,'/v1/files/a712a287b77144f19737b4b5fd90bf40.jpg','1','2018-06-23 11:54:04','2018-07-16 18:37:57',0,0,'1'),
	('5b0393737b75903a27b486b3','5acd8b68d487e1be9eb5f8aa','胡亮','huliang','$2a$10$iECkSdWhlMaBZoqJ3Jt8tuhBooBXbEC2eD9m.mADt24NRiYDQvrXW','','','医生','clinic',NULL,'/v1/files/86b1226c7fba4a6f81d7d98cda736d22.jpg','1','2018-07-11 11:47:00','2018-10-30 09:44:35',0,0,'9981'),
	('5c19bcff9e5909046d78a5b2','5acd8b68d487e1be9eb5f8aa','左瑛','1919','$2a$10$ylIGUdQ0ySIx0MFOeCSDluVvNks2lAmO7aNP.BYplv1E5rXEVLQoi','13011111111',NULL,'护士','','b_ultrasound','/v1/files/3b79b571d00347089ab52cf8e45307f6.png','5','2018-12-19 11:37:35','2018-12-19 11:38:04',0,0,'1919');

/*!40000 ALTER TABLE `t_doctor` ENABLE KEYS */;
UNLOCK TABLES;
```

<br/>

### 2-3、运行
```
docker build -t xx-mysql:1.0.0 .

docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 xx-mysql:1.0.0
```

<br/>

## 三、创建实例并初始化多个sql脚本
如果有多个sql文件，无法保证执行顺序，这就需要引入 sh 文件，思路是在docker-entrypoint-initdb.d 目录下放置 sh 文件，在 sh 文件中依次执行 sql 文件，编写Dockerfile、install_db.sh、init_database.sql、init_table.sql、init_data.sql 文件

### 3-1、Dockerfile文件
```
#基础镜像使用 mysql:latest
FROM mysql:5.7

#定义工作目录
ENV WORK_PATH /usr/local/work

#定义会被容器自动执行的目录
ENV AUTO_RUN_DIR /docker-entrypoint-initdb.d

#定义sql文件名
ENV FILE_0 init_database.sql 
ENV FILE_1 init_table.sql
ENV FILE_2 init_data.sql

#定义shell文件名
ENV INSTALL_DB_SHELL install_db.sh

#创建文件夹
RUN mkdir -p $WORK_PATH

#把数据库初始化数据的文件复制到工作目录下
COPY ./$FILE_0 $WORK_PATH/
COPY ./$FILE_1 $WORK_PATH/
COPY ./$FILE_2 $WORK_PATH/

#把要执行的shell文件放到/docker-entrypoint-initdb.d/目录下，容器会自动执行这个shell
COPY ./$INSTALL_DB_SHELL $AUTO_RUN_DIR/

#给执行文件增加可执行权限
RUN chmod a+x $AUTO_RUN_DIR/$INSTALL_DB_SHELL
```

<br/>

### 3-2、install_db.sh
```
mysql -uroot -p$MYSQL_ROOT_PASSWORD << EOF
source $WORK_PATH/$FILE_0;
source $WORK_PATH/$FILE_1;
source $WORK_PATH/$FILE_2; 
```

<br/>

### 3-3、init_database.sql
```
CREATE DATABASE IF NOT EXISTS my_db default charset utf8 COLLATE utf8_general_ci;
```

<br/>

### 3-4、init_table.sql
```
-- 设置字符编码，创建表的语句
set character_set_client=utf8mb4;

-- 设置字符编码，插入数据的编码
set character_set_connection=utf8mb4;

use my_db;

DROP TABLE IF EXISTS `table1`;

CREATE TABLE `table1` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL COMMENT '姓名',
  `age` int(11) DEFAULT NULL COMMENT '年龄',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

<br/>

### 3-5、init_data.sql
```
-- 设置字符编码，创建表的语句
set character_set_client=utf8mb4;

-- 设置字符编码，插入数据的编码
set character_set_connection=utf8mb4;

use my_db;

INSERT INTO `table1` (`id`, `name`, `age`)
VALUES
    (1,'姓名1',10),
    (2,'姓名2',11);
```