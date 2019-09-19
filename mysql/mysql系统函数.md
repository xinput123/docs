#### 查询自动提交模式
```
show variables like 'AUTOCOMMIT';
```

#### 设置提交模式
```
SET AUTOCOMMIT = 1;
```
> 1和ON表示自动提交，0和OFF表示禁用。当AUTOCOMMIT = 0时，所有的查询都是在一个事务中，直到显示地执行commit或者rollback回滚。**alter table等会导致大量数据改变的操作以及LOCK TABLES等其他语句会导致执行之前强制commit提交当前的活动事务**

#### 设置隔离级别
```
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITED;
```
> 新的隔离级别会在下一个事务开始的时候生效。可以在配置文件中设置整个数据库的隔离级别，也可以只改变当前会话的隔离级别。

#### 显示表的相关信息 
```
show table status; 显示当前库小所有的表的信息。

// 显示表名=checking的相关信息。
show table status where name= 'checking';
```

