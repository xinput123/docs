## 一、MySQL(INSERT、UPDATE)
#### 1、mysql表添加字段，指定插入位置，默认是插入到最后一列
```
// 添加 列 到第一列
ALTER TABLE tableName ADD COLUMN 列名 VARCHAR(50)  first;

// 指定列的后面
ALTER TABLE tableName ADD COLUMN 列名 VARCHAR(50) after note;

// 修改列、字段的位置，如 将parent_office_id  修改到列office_name后面。
ALTER TABLE office MODIFY parent_office_id 约束  AFTER office_name;

// id放到第一列
ALTER TABLE student MODIFY id varchar(20) FIRST;

// 指定列的后面
ALTER TABLE test_demo ADD COLUMN status CHAR(2) NULL DEFAULT NULL COMMENT '状态' after name  ;

// 指定字段的备注信息
alter table drug_regulatory_code  MODIFY  `code_level` VARCHAR(64) NULL DEFAULT NULL COMMENT '级别 1小 2中 3大';
```

##### 2、主键，索引的增加和修改
```
// 先删除主键
alter table table_test drop primary key;

// 增加主键
alter table table_test add primary key(id); 

// 删除索引
drop index indexName on talbeName;

// 多列索引
alter  table tableName  ADD  INDEX indexName( claim_number, account_file_no);
```

##### 3、对datetime 字段类型的数据做修改
```
// 减法 减去 n 天
update  tableName set DATETIME字段名 = DATE_SUB(DATETIME字段名, INTERVAL n day) WHERE 条件;

// 加法 增加 m 天
update  tableName set DATETIME字段名 = DATE_ADD(DATETIME字段名, INTERVAL m day) WHERE 条件;
```

##### 4、INSERT INTO ... SELECT
```
INSERT INTO  thorn_tasks  (ID, SUBSCRIBER, TYPE, MESSAGE_ID, CREATE_TIME, STATUS, REPEAT_COUNT)
SELECT SEQ_THORN_TASK.NEXTVAL,'feeManager.lfcsCbYjs', 'LFCS_CB_YJS',sd.id,s.leave_time,'READY',0    
FROM shipment_detail sd
LEFT JOIN shipment s on s.id=sd.shipment_id
WHERE 1=1
AND s.leave_time>=to_date('2015-08-26','yyyy-mm-dd')
AND sd.id not in (
  select t.message_id  --  25675
  from thorn_tasks t
  where t.subscriber='feeManager.lfcsCbYjs'
  and t.create_time>=to_date('2015-08-26','yyyy-mm-dd')
) ;
```
<br>
<br>
<br>
## 二、MySQL查询  SELECT
#### 1、按照天，月，年，所有统计商户信息

```
SELECT c.id AS '商户', c.date AS '日期', SUM(c.c1) AS '成功订单数', SUM(c.c2) AS '订单总数', SUM(c.s1) AS '成功订单金额', SUM(c.s2) AS '订单总额' 
	FROM (
		-- 统计每天每个商户成功付款订单
		SELECT DATE_FORMAT( a.accounts_receipt_date, '%Y-%m-%d' ) AS DATE, 
			a.accounts_business_id AS id, COUNT(1) AS c1, 0 AS c2, 
			SUM(a.accounts_order_money) AS s1, 0 AS s2 
		FROM t_accounts a 
		WHERE a.accounts_business_id <> '100001' 
		GROUP BY a.accounts_business_id, DATE_FORMAT( a.accounts_receipt_date, '%Y-%m-%d' ) 
		
		UNION ALL 

		-- 统计每天成功向银行提交的订单
		SELECT DATE_FORMAT( ro.rel_order_date, '%Y-%m-%d' ) AS DATE, 
		ro.rel_order_business_id AS id, 0 AS c1, COUNT(1) AS c2, 
		0 AS s1, SUM(ro.rel_order_money) AS s2 
		FROM t_rel_order ro 
		WHERE ro.rel_order_business_id <> '100001' 
		GROUP BY ro.rel_order_business_id, DATE_FORMAT( ro.rel_order_date, '%Y-%m-%d' ) 
		
		UNION ALL 

		-- 统计每个月每个商户
		SELECT DATE_FORMAT( a.accounts_receipt_date, '%Y-%m' ) AS DATE, 
		a.accounts_business_id AS id, COUNT(1) AS c1, 0 AS c2,
		SUM(a.accounts_order_money) AS s1, 0 AS s2 
		FROM t_accounts a 
		WHERE a.accounts_business_id <> '100001' 
		GROUP BY a.accounts_business_id, DATE_FORMAT( a.accounts_receipt_date, '%Y-%m' ) 
		
		UNION ALL 

		-- 统计每个月每个商户成功向银行提交的订单
		SELECT DATE_FORMAT(ro.rel_order_date, '%Y-%m') AS DATE, 
		ro.rel_order_business_id AS id, 0 AS c1, COUNT(1) AS c2, 
		0 AS s1, SUM(ro.rel_order_money) AS s2 
		FROM t_rel_order ro 
		WHERE ro.rel_order_business_id <> '100001' 
		GROUP BY ro.rel_order_business_id, DATE_FORMAT(ro.rel_order_date, '%Y-%m') 
		
		UNION ALL 

		-- 统计每年每个商户
		SELECT DATE_FORMAT( a.accounts_receipt_date, '%Y' ) AS DATE, 
		a.accounts_business_id AS id, COUNT(1) AS c1, 0 AS c2, 
		SUM(a.accounts_order_money) AS s1, 0 AS s2 
		FROM t_accounts a 
		WHERE a.accounts_business_id <> '100001' 
		GROUP BY a.accounts_business_id, DATE_FORMAT( a.accounts_receipt_date, '%Y' ) 
		
		UNION ALL 

		-- 统计每年每个商户成功向银行提交的订单
		SELECT DATE_FORMAT(ro.rel_order_date, '%Y') AS DATE, 
		ro.rel_order_business_id AS id, 0 AS c1, COUNT(1) AS c2, 
		0 AS s1, SUM(ro.rel_order_money) AS s2 
		FROM t_rel_order ro 
		WHERE ro.rel_order_business_id <> '100001' 
		GROUP BY ro.rel_order_business_id, DATE_FORMAT(ro.rel_order_date, '%Y') 
		
		UNION ALL 

		-- 统计每个商户下成功付款的订单
		SELECT NULL AS DATE, a.accounts_business_id AS id, COUNT(1) AS c1, 
		0 AS c2, SUM(a.accounts_order_money) AS s1, 0 AS s2 
		FROM t_accounts a 
		WHERE a.accounts_business_id <> '100001' 
		GROUP BY a.accounts_business_id 
		
		UNION ALL 

		-- 统计每个商户总共向银行提交的订单
		SELECT NULL AS DATE, ro.rel_order_business_id AS id, 0 AS c1, 
		COUNT(2) AS c2, 0 AS s1, SUM(ro.rel_order_money) AS s2 
		FROM t_rel_order ro 
		WHERE ro.rel_order_business_id <> '100001' 
		GROUP BY ro.rel_order_business_id ) c 
		GROUP BY c.id, c.date 
	-- order by c.id,date;
	ORDER BY c.id, CASE WHEN c.date IS NULL THEN 1 ELSE 0 END, DATE;
```

##### 2、查看视图创建的sql语句
```
SHOW CREATE VIEW 视图名;
```

##### 3、查看MySQL中表中的存储引擎类型？
```
SHOW table status from 数据库库名 where name='表名'
```
>注：有时候，这种方法也不一定准确，服务器配置没有启用InnoDB存储引擎，在创建表的时候设置的是InnoDB存储引擎，创建表时的命令：
    show create table 表名

##### 4、查看mysql服务器启用的引擎。
```
SHOW ENGINES;
```
> Engine参数指存储引擎名称；    
> Support参数说明MySQL是否支持该类引擎，YES表示支持；
> Comment参数指对该引擎的评论；   
> Transactions参数表示是否支持事务处理，YES表示支持；
> XA参数表示是否分布式交易处理XA规范，YES表示支持；
> Savepoints参数表示是否支持保存点，以便事务回滚到保存点，YES表示支持。
从查询结果中可以看出，MySQL支持的引擎参数包括MyISAM、MEMORY、InnoDB、ARCHIVE和MRG_MYISAM等。其中InnoDB为默认的存储引擎。

##### 5、查看mysql版本号。
```
show variables like 'version';  或者
select version();
```

### 三、MySQL字段类型
##### 1、时间类型
| 日期类型  | 存储空间 | 日期格式             |日期范围|
|:--------  |:-------- |:-----                | :----- |
| datetime  | 8 bytes  | YYYY-MM-DD HH:MM:SS  | 1000-01-01 00:00:00 ~ 9999-12-31 23:59:59
| timestamp | 4 bytes  | YYYY-MM-DD HH:MM:SS  | 1970-01-01 00:00:01 ~ 2038
| date      | 3 bytes  | YYYY-MM-DD           | 1000-01-01 ~ 9999-12-31 
| year      | 1 bytes  | YYYY                 | 1901 ~ 2155

##### 2、数字类型
| 数字类型          | 存储空间 |取值范围 |
|:--------          |:-------- | :-----  |
| bigint            | 8 bytes  | -2^63 (-9223372036854775808) ~ 2^31 – 1 (2,147,483,647)
| int               | 4 bytes  | -2^31 (-2,147,483,648) ~ 2^31 – 1 (2,147,483,647)
| mediumint         | 3 bytes  | -8388608 ~ 8388607
| smallint          | 2 bytes  | -2^15 (-32,768) ~ 2^15 – 1 (32,767)
| TINYINT 有符号    | 1 bytes  | -128 ~ 127
| TINYINT UNSIGNED  | 1 bytes  | 0 ~ 255
| FLOAT(p)  | 如果0 <= p <= 24为4个字节, 如果25 <= p <= 53为8个字节  | 
| FLOAT  | 1 bytes  | 
| DOUBLE [PRECISION], item REAL  | 4 bytes  | 
| DECIMAL(M,D), NUMERIC(M,D)  | 变长（0-4个字节）  | 
| BIT(M)  | 大约(M+7)/8个字节  | 

###### 3、字符串类型
| 字符串类型                 | 存储空间 |
|:--------                   |:-------- |
| CHAR(M)                    | M个字节，0 <= M <= 255  |
| VARCHAR(M)                 | L+1个字节，其中L <= M 且0 <= M <= 65535  |
| BINARY(M)                  | M个字节，0 <= M <= 255  |
| VARBINARY(M)               | L+1个字节，其中L <= M 且0 <= M <= 255  |
| TINYBLOB, TINYTEXT         | L+1个字节，其中L < 28  |
| BLOB, TEXT                 | L+2个字节，其中L < 216  |
| MEDIUMBLOB, MEDIUMTEXT     | L+3个字节，其中L < 224  |
| LONGBLOB, LONGTEXT         | L+4个字节，其中L < 232  |
| ENUM(‘value1’,’value2’,…)  | 1或2个字节，取决于枚举值的个数(最多65,535个值)  |
| SET(‘value1’,’value2’,…)   | 1、2、3、4或者8个字节，取决于set成员的数目(最多64个成员)  |


### 四、约束的禁用和开启
###### 4-1、索引
```
alter table disable keys;  -- 禁用索引
alter table enable keys;  -- 禁用索引
```

###### 4-2、唯一性检查
```
set unique_checks=0; -- 禁用唯一性检查
set unique_checks=1; -- 开启唯一性检查
```