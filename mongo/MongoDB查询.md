# 一、普通查询
#### 1、单一条件
```
// 等于: senderId="5ae10bf940658909f9742684"
db.notify.find({senderId : "5ae10bf940658909f9742684"})

// 小于: recordState < 2
db.notify.find({recordState : {$lt:2} })

// 小于或等于: recordState <= 2
db.notify.find({recordState : {$lte:2} })

// 大于: recordState > 2
db.notify.find({recordState : {$gt:2} })

// 大于或等于: recordState >= 2
db.notify.find({recordState : {$gte:2} })
```
<br/>
#### 2、AND 条件
```
// senderId="5ae10bf940658909f9742684" and notifyType="im_patient_to_doctor"
db.notify.find({senderId:"5ae10bf940658909f9742684",notifyType:"im_patient_to_doctor"})
```
<br/>
#### 3、OR 条件
```
// recordState=3 or recordState=4
db.notify.find({$or:[ {recordState:3},{recordState:4} ] })
```
<br/>
#### 4、And 和 Or 共同使用
```
// notifyType=remind_registered and (senderId="5af3ee3740658957eb6941f5" or senderId="5afa85ef40658957eb6941fc")
db.notify.find({notifyType:"remind_registered",$or:[{senderId:"5af3ee3740658957eb6941f5"},{senderId:"5afa85ef40658957eb6941fc"}]})
```
<br/>
##### 5、返回指定字段(一种是返回指定的键，不反悔其他的键；一种是不反悔指定的键，返回其他键)
```
// inclusion模式 指定返回的键，不返回其他键
db.notify.find({notifyType:"remind_registered"},{"senderId":1,by:1})
db.notify.find({notifyType:"remind_registered"},{"senderId":1})

// exclusion模式 指定不返回的键,返回其他键
db.notify.find({notifyType:"remind_registered"},{"senderId":0,by:0})
db.notify.find({notifyType:"remind_registered"},{"senderId":0})
```
>- db.collection.find(query, projection) 若不指定 projection，则默认返回所有键
>- **只能全1或全0，除了在inclusion模式时可以指定_id为0**
>- db.notify.find({notifyType:"remind_registered"},{"senderId":1,"_id":0})  可以只返回senderId而不反悔_id.

<br/>
##### 6、模糊查询
```
// 查询 title 包含"在"字的文档
db.notify.find({content:/在/})

// 查询 title 字段以"在"字开头的文档
db.notify.find({content:/在/})

// 查询 titl e字段以"在"字结尾的文档：
db.notify.find({content:/在/})
```

<br/>

# 二、复杂查询：聚合管道 aggregate
- $和字段名在一起时，需要用双引号括起来

#### aggreate和sql对比
- $match WHERE
- $group GROUP BY
- $project SELECT
- $sort ORDER BY
- $limit LIMIT
- $sum SUM()
- $sum COUNT()

<br/>
### 1、$match  
- 筛选条件，过滤不满足条件的文档，可使用常规查询操作符

```
// 查询orders集合中status="A"的数据
db.orders.aggregate([
  {$match:{status:"A"}}
])
```

### 2、$project  
- 用于包含、排除字段，设置需查询或过滤的字段，0为过滤掉字段不显示，1为需查询的字段。
- 用于对字段重命名
- 投射中可使用表达式

```
// 查询users表的username和age字段
db.orders.aggregate([
  {$match:{status:"A"}},
  {$project:{_id:0,cust_id:1,amount:1,status:1}}
])

// $project 当字段值为0或1时用于过滤字段，当键名为一个自定义的字符串，键值为$紧跟原字段表示要对该字段进行重命名。
db.users.aggregate(
  {$match: {age: {$gte: 18}}},
  {$project: {_id:0, nickname:"$username"}}
)

// 通过修改字段名达到生成字段副本，以便后续操作符使用。
db.users.aggregate(
  { $match: {age: {$lte: 18 } } },
  { $project: {id:"$_id", username:1 } }
)
```

<br/>
#### 算术表达式可对数值运算
- $运算符 后面的[] 可以表示多个元素

```
// 对 score 字段值加1后作为 scores 的值
db.users.aggregate([
  { $project: {scores: { $add : ["$score",1]  } } }
])

// 对 score 字段值减1后作为 scores 的值
db.users.aggregate([
  { $project: {scores: { $subtract : ["$score",1]  } } }
])

// 对 score 字段值乘2后作为 scores 的值
db.users.aggregate([
  { $project: {scores: { $multiply : ["$score",2]  } } }
])

// 对 score 字段值除2后作为 scores 的值
db.users.aggregate([
  { $project: {scores: { $divide : ["$score",2]  } } }
])

// 对 score 字段值除50后的余数作为 scores 的值
db.users.aggregate([
  { $project: {scores: { $mod : ["$score",50]  } } }
])
```
<br/>
#### 字符串操作
```
// $substr:[exp, startOffset, numToReturn] 字符串截取
db.users.aggregate([
  { $project: {nickname: {  $substr:[ "$username",1,10 ]  } } }
])

// $concat:[exp1, exp2, exp3...] 字符串拼接，将数组中多个元素拼接在一起
db.users.aggregate([
  { $project: {fullName: {  $concat:[ "$fisrtName","$lastName"]  } } }
])

// $toLower:exp 字符串转为小写
db.users.aggregate([
  { $project: {nickName:{$toLower:"$username"} } }
])

// $toUpper:exp 字符串转为大写
db.users.aggregate([
  { $project: {nickName:{$toUpper:"$username"} } }
])
```

<br/>
#### 日期表达式
```
db.users.aggregate([
  {
      $project:{ 
         'year':{$year:"$publish_at"},
         'month':{$month:"$publish_at"},
         'dayOfMonth':{$dayOfMonth:"$publish_at"},
         'dayOfWeek':{$dayOfWeek:"$publish_at"},
         'dayOfYear':{$dayOfYear:"$publish_at"},
         'hour':{$hour:"$publish_at"},
         'minute':{$minute:"$publish_at"},
         'second':{$second:"$publish_at"}
      } 
   }
])
```

<br/>
####  时间间隔
```
// $cmp:[exp1, exp2] 字符串比较，相同为0，小于返回负数， 大于返回正数
db.users.aggregate([
  { $project: {result:{$cmp:["$age",18]} } }
])

// $strcasecmp:[exp1, exp2] 字符串比较，相同为0，小于返回-1， 大于返回1
db.users.aggregate([
  { $project: {result:{$strcasecmp:["$username","zhangsan"]} } }
])
```

<br/>
#### 逻辑条件
```
// $eq 判断表达式是否相等
db.users.aggregate([
  { $project: { result : {$eq: ["$username", 'ZhangSan' ] } } }
])

// $and [exp1, exp2...expn] 连接多条件，所有条件为真则表达式为真
db.users.aggregate([
  { $project: { result: { $and : [ {$eq:["$username",'zhangsan']},{$gt:["$age",18]} ] } }  }
])

// $not exp 用于取反操作
db.users.aggregate([
  { $project: { result : {$not:{$eq: ["$username", 'ZhangSan' ] }} } }
])

// $cond:[booleanExp, trueExp, falseExp] 三目运算符
db.users.aggregate([
  {$project : { result: {$cond:[{$eq:["$username",'junchow']}, true, false] } }}
])

// $ifNull:[exp, replacementExpr] 若条件为null则返回表达式值，若字段不存在时字段值为null
db.users.aggregate([
  {$project: { result: { $ifNull : [ "$username", 'not exist is null' ] } }}
])
```

<br/>

### $group
- $group分组使用_id指定要分组的键名，用来自定义字段统计。

```
// age>18,根据firstName进行分组
db.users.aggregate([
  {$match : { age: { $gte : 18 } } },
  {$group : { _id:"$fisrtName", count:{$sum:1} }}
]);

// 多字段分组
db.users.aggregate([
  {$match: {age: {$gte:18}  }},
  {$group: {_id:{username:"$username", age:"$age"}, 'count':{$sum:1} } }
])

// $sum:val 对每个文档加val求和
db.users.aggregate([
  {$group: { _id:"$fisrtName", sumAge:{$sum:"$age"} }}
])

// $avg:val 对每个文档求均值
db.users.aggregate([
  {$group: { _id:"$fisrtName", count:{$avg:"$age"} }}
])

// $max:val，$mix:val 对每个文档求最值
db.users.aggregate([
  {$group: { _id:"$fisrtName", maxAge:{$max:"$age"}, minAge:{$min:"$age"} }}
])

// $first:val 获取分组中首个
db.users.aggregate([
  {$group: { _id:"$fisrtName", count:{$first:"$age"} }}
])

// $last:val 获取分组中最后一个
db.users.aggregate([
  {$group: { _id:"$fisrtName", last:{$last:"$age"} }}
])  
```

#### 查询姓氏下人的个数
- SELECE COUNT(*) FROM users where 1=1 group by firstName;
```
db.users.aggregate([
  {$group:{_id:"$firstName",count:{$sum:1}}},
  {$project:{_id:0,firstName:"$firstName",count:"$count"}},
  {$sort:{count:1}}
])
```

<br/>

## 三、聚合运算 group
### 1、group
- 先选定分组所依据的键，而后将集合依据选定键值的不同分成若干组。然后可通过聚合每一组内的文档，产生一个结果文档。
- group不支持分片集群，无法进行分布式运算（shard cluster）。若需要支持分布式需使用aggregate或mapReduce。

##### 语法
```
db.collection.group(document){
  key:{key1, key2:1},
  keyf:function(doc){ return ...},
  cond:{},
  reduce:function(current, result){},
  initial:{},
  finalize:function(){}
}
```
>- **key:{key1, key2:1},** 分组字段
> 
>- **keyf:function(doc){ return ...},** 通过函数处理的字段
> 
>- **cond:{},** 查询条件
> 
>- **reduce:function(current, result){},** 聚合条件。**current** 对应当前行;**result** 对应分组中的多行
> 
>- **initial:{},** 初始化
> 
>- **finalize:function(){}** 统计一组后的回调函数


<br/>
##### 查询每个姓氏下的人数   
- select fisrtName,count(*) from users group by fisrtName;

```
db.users.group({
  key:{fisrtName:1},
  cond:{},
  initial:{total:0},
  reduce:function(current,result){
    result.total += 1;    
  }
})
```

##### 查询每个姓氏下大于18岁的人数   
- select fisrtName,count(*) from users where age>18 group by fisrtName;

```
db.users.group({
  key:{fisrtName:1},
  cond:{age:{$gt:18}},
  reduce:function(current,result){
    result.total += 1;    
  },
  initial:{total:0}  
})
```

##### 查询每个姓氏下分数总和
- select firstName,sum(score) from users where 1=1 group by fisrtName;

```
db.users.group({
  key:{fisrtName:1},
  cond:{},
  initial:{sumScore:0},
  reduce:function(current,result){
    result.sumScore += current.score;    
  }
})
```

##### 查询每个姓氏下的最高分
- SELECT fisrtName,MAX(score) FROM goods GROUP BY fisrtName

```
db.users.group({
  key:{fisrtName:1},
  cond:{},
  initial:{maxScore:0},
  reduce:function(current,result){
    if(current.score > result.maxScore){
        result.maxScore = current.score;    
    }
  }
})
```

##### 查询每个姓氏下的平均分
- SELECT fisrtName,average(price) FROM goods GROUP BY fisrtName

```
db.users.group({
  key:{fisrtName:1},
  cond:{},
  initial:{total:0, count:0}, //进组result
  reduce:function(current,result){
    result.total += current.score;
    result.count  += 1;
  },
  finalize:function(result){ //出组 result
    result.average = result.total/result.count;
  }
})
```

##### 

```
db.notify.group({
 keyf : function(doc){
 var date = new Date(doc.createTime);
 var dateKey = ""+date.getHours();
 return {'hours':dateKey}; //33
}, 
 initial : {"count":0}, 
 reduce : function Reduce(doc, out) {
 if(doc.notifyType=='im_patient_to_team'){
  out.count +=1;
 }
},
$sort:{hours:1}
});
```

>- var year = ""+date.getFullYear();  // 2018
>- var month = ""+date.getMonth(); // 月份，0-11，所以计算时需加1
>- var day = ""+date.getDate();  // 日期，1-30
>- var dayOfWeek = ""+date.getDay();  // 星期几，0-6
>- var hours = date.getHours();  // 小时 0-23
>- var hours = date.getMinutes();  // 分钟 0-59


# 四、MapReduce
mapReduce是一个轻松并行化到多台服务器的聚合方法，它会拆分问题，再将各个部分发送到不同机器上，让每台机器都完成一部分。当所有机器都完成后，再将结果汇集起来形成最终完整的结果。

```
db.runCommand({
  mapreduce:字符串,集合名
  map:函数,
  reduce:函数,
  [query:文档，发往map()前先给过渡的文档],
  [sort:文档，发往map()前先给文档排序],
  [limit:整数，发往map()的文档数量上限],
  [out:字符串，统计结果保存的集合],
  [keeptemp:布尔值，链接关闭时临时结果集合是否保存],
  [finalize:函数，将reduce的结果发给此函数做最后处理],
  [scope:文档，js代码中要用到的变量],
  //jsMode=true时 BSON>JS>map>reduce>BSON
  //jsMode=false时 BSON>JS>map>BSON>JS>reduce>BSON，可处理非常大的mapreduce
  [jsMode:布尔值，是否减少执行过程中BSON和JS的转换，默认为true]，
  [verbose:布尔值，是否产生更加详细的服务器日期，默认为true]
})
```

```
var map = function(){
  emit(this.username, this.score);
}
var reduce = function(key,score){
  return Array.sum(score);
}
db.users.mapReduce(map,reduce,{query:{},out:"result"});
```


