## 一、锁、死锁
#### 1、查看mysql锁
```
-- 查看mysql死锁日志
show engine innodb status;
```

#### 2、查看锁事务
```
-- 查看正在锁的事务
SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCKS;
-- 查看等待锁的事务
SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCK_WAITS;
-- 查看是否有锁定的
SELECT * FROM information_schema.INNODB_TRX;
```

#### 3、显示谁阻塞和谁等待
```
SELECT r.`trx_id` AS waiting_trx_id,r.`trx_mysql_thread_id` AS waiting_thread,
  TIMESTAMPDIFF(SECOND,r.`trx_wait_started`,CURRENT_TIMESTAMP) AS wait_time,
  r.`trx_query` AS waiting_query,
  l.`lock_table` AS waiting_table_lock,
  b.`trx_id` AS blocking_trx_id, b.`trx_mysql_thread_id` AS blocking_thread,
  SUBSTRING(p.`HOST`,1,INSTR(p.host,':')-1) AS blocking_host,
  SUBSTRING(p.`HOST`,INSTR(p.host,':')+1) AS blocking_port, 
  IF(p.`COMMAND`="Sleep",p.`TIME`,0) as idle_in_trx,
  b.`trx_query` as blocking_query 
FROM `information_schema`.`INNODB_LOCK_WAITS` w
INNER JOIN `information_schema`.`INNODB_TRX` b ON b.`trx_id`=w.`blocking_trx_id`
INNER JOIN `information_schema`.`INNODB_TRX` r ON r.`trx_id`=w.`requesting_trx_id`
INNER JOIN `information_schema`.`INNODB_LOCKS` l ON w.`requested_lock_id`=l.`lock_id`
LEFT JOIN `information_schema`.`PROCESSLIST` p ON p.id=b.`trx_mysql_thread_id`
ORDER BY wait_time;
```

假如返回数据如下

```
waiting_trx_id : 5d03
waiting_thread : 3
wait_time : 6
waiting_query : select * from t_doctor limit 1 for update;
waiting_table_lock : dpcp.doctor
blocking_trx_id : 5d02
blocking_thread : 2
blocking_host : localhost
blocking_port : 9090
idle_in_trx : 8
blocking_query : NULL
```
- **结果表示线程3已经等待了doctor表中的锁达6秒了。它在线程2上被阻塞，而该线程已经空闲了8秒。**
