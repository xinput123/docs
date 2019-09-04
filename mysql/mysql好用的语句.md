#### 1、length() 和 char_length() 
```
select u.id,u.name,length(u.name) as nameLength from test_demo u where 1=1

select u.id,u.name,char_length(u.name) as nameCharLength from test_demo u where 1=1 ;
```

**比较 length 和 char_length 的不同：**

- **length**: 一个汉字是算三个字符，一个数字或字母算一个字符。
- **char_length**: 不管汉字还是数字或者是字母都算是一个字符。

<br/>
#### 2、GROUP_CONCAT（）函数。我们在查询数据时，不但不需要对某一个字段进行分组，还要组合另外一个字段的所有值。
```
select d.demoDate,d.demoContext,GROUP_CONCAT(d.stuName) from demo d group by d.demoDate ;
```

**GROUP_CONCAT(
    [DISTINCT] columnName[,columnName...]
    [ORDER BY {unsigned_integer | col_name | formula} [ASC | DESC] [,col ...]]
    [SEPARATOR str_val]
)**
> - DISTINCT 可以排除重复值。如果希望对结果中的值进行排序，可以使用 ORDER BY 子句；
> - SEPARATOR 是一个字符串值，它被用于插入到结果值中。缺省为一个逗号 (",")，可以通过指定 SEPARATOR "" 完全地移除这个分隔符；
> - 变量 group_concat_max_len 可以设置一个最大的长度。在运行时执行的句法如下： SET [SESSION | GLOBAL] group_concat_max_len = unsigned_integer;
如果最大长度被设置，结果值被剪切到这个最大长度。如果分组的字符过长，可以对系统参数进行设置：SET @@global.group_concat_max_len=40000。

<br/>
#### 3、对指定字段的数据进行筛选，并统计值  status=1的个数。
```
select d.demoDate,
	d.demoContext,
	GROUP_CONCAT(d.stuName) ,
	count(d.demoDate),
	sum(if(d.`status`=1,1,0)) 
from demo d 
group by d.demoDate 
```
- sum是个很有用的函数，例如在统计某一个字段中满足条件的个数，则可以使用 sum(if(column? value1,value2))。即 column满足条件，则设置为value1，否则value2。

<br/>
#### 4、对于包含null值的字段排序
order by xxx ASC排序时，字段为空值时，默认排在最前面；而为DESC排序时，字段为空值时，默认排在最后面；如果希望空值不按照默认方式来排序，该怎么处理呢？

```
order by if(isnull(xxx),1,0),xxx ASC
```
- 这时候相当于先将 xxx字段中是null的和非null的进行排序，再排序xxx。

<br/>
#### 5、MySQL统计过去12个月的数据(包括本月)。
```
SELECT 
	DATE_FORMAT(so.send_drug_date,'%Y-%m') AS month, 
	count(so.order_id) AS orderCount
FROM stat_orders so
WHERE 1=1
AND DATE_FORMAT(so.send_drug_date,'%Y-%m')>DATE_FORMAT(date_sub(curdate(), interval 12 MONTH),'%Y-%m')
group by DATE_FORMAT(so.send_drug_date,'%Y-%m')
order by month; 
```

- DATE_ADD(date,INTERVAL expr type) 和 DATE_SUB(date,INTERVAL expr type)这些函数执行日期运算。 date 是一个 DATETIME 或DATE值，用来指定起始时间。 expr 是一个表达式，用来指定从起始日期添加或减去的时间间隔值。  Expr是一个字符串;对于负值的时间间隔，它可以以一个 ‘-’开头。 type 为关键词，它指示了表达式被解释的方式。 

<br/>
#### 6、mysql两个字段的LIKE  like concat('%',字段,'%')
```
select w.`药品id`
from wanhu_drug w
inner join drug_info d on w.`通用名`= d.`通用名` and w.`商品名`=d.`商品名`
where 1=1
and (w.`生产厂家`=d.`厂家产地`
	or w.`生产厂家` like concat('%',d.`厂家产地`,'%')
	or d.`厂家产地` like  concat('%',w.`生产厂家`,'%')
);
```

<br/>
#### 7、查询使用逗号拼接的sql
```
select * from user where concat(',',owner_id,',') REGEXP ',6,';
```

<br/>
#### 8、DATE_FORMAT() 函数用于以不同的格式显示日期/时间数据。
```
DATE_FORMAT(date,format) 
```

**format 参数的格式有很多：**

- %a 缩写星期名
- %b	缩写月名
- %c	月，数值
- %D	带有英文前缀的月中的天
- %d	月的天，数值(00-31)
- %e	月的天，数值(0-31)
- %f	微秒
- %H	小时 (00-23)
- %h	小时 (01-12)
- %I	小时 (01-12)
- %i	分钟，数值(00-59)
- %j	年的天 (001-366)
- %k	小时 (0-23)
- %l	小时 (1-12)
- %M	月名
- %m	月，数值(00-12)
- %p	AM 或 PM
- %r	时间，12-小时（hh:mm:ss AM 或 PM）
- %S	秒(00-59)
- %s	秒(00-59)
- %T	时间, 24-小时 (hh:mm:ss)
- %U	周 (00-53) 星期日是一周的第一天
- %u	周 (00-53) 星期一是一周的第一天
- %V	周 (01-53) 星期日是一周的第一天，与 - %X 使用
- %v	周 (01-53) 星期一是一周的第一天，与 - %x 使用
- %W	星期名
- %w	周的天 （0=星期日, 6=星期六）
- %X	年，其中的星期日是周的第一天，4 位，与 - %V 使用
- %x	年，其中的星期一是周的第一天，4 位，与 - %v 使用
- %Y	年，4 位
- %y	年，2 位