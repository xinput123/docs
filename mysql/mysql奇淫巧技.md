#### 1、用户自定义变量
```
mysql> set @rownum := 0;
mysql> select id,price,@rownum:=@rownum+1 as rownum
from money;
```
![image.png](https://upload-images.jianshu.io/upload_images/4046640-04ed7b95750a9bef.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


``` 
-- 更新，设置自动自动增长
set @rownum := 0;
update t_insp_check set insp_sort= (@rownum:=@rownum+1) where insp_type_sort=13;
```

#### 2、在mysql中给查询的结果添加序号
```
Select (@i:=@i+1) as RowNum, a.* from Table1 a,(Select @i:=0) B order by a.id desc limit 0, 10;
```

#### 3、mysql生成随机数
```
select ROUND(RAND()*(max-min)+min);
```
- max 最大值
- min 最小值

#### 4、看一条语句，mysql给出的优化建议
```
explain extended select * from (select * from film where id = 1) tmp;
show warnings;
```