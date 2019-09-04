## 一、索引
#### 1-1、创建/重建 索引
```
db.loginfo.ensureIndex({"date":-1})

db.test.createIndex({"username":1},{"background":true})

db.test.ensureIndex({"userid":1,"age":1},{"unique":true}) 
  
db.user.reIndex({name:-1})  -- 重建集合user中的name索引
```
>- ensureIndex 和 createIndex 都是创建索引的命令
>- db.COLLECTION_NAME.ensureIndex({KEY:1}) 语法中 Key 值为你要创建的索引字段，1为指定按升序创建索引，如果你想按降序来创建索引指定为-1即可。
>- {"background":true} 表示MongoDB在后台创建索引，这样的创建时就不会阻塞其他操作。
>- {"unique":true} 保证复合键值唯一性，相当于mysql的唯一索引。

#### 1-2、查看索引
```
db.collectionName.getIndexes()    -- 查看集合collectionName的所有索引

db.collectionName.getIndices()    -- 查看集合collectionName的所有索引

db.collectionName.getIndexKeys()    -- 查看集合collectionName的所有索引的key，即字段

db.collectionName.totalIndexSize()  --查看集合索引的总大小
```
>- getIndexes() 和getIndices()以及getIndexSpecs 都可以获取索引

#### 1-3、删除索引
```
db.loninfo.dropIndex("yuan")   --删除指定集合loninfo中的名为yuan的索引。

db.abc.dropIndexes( )   --删除集合abc中的所有索引。
```

<br/>

## 二、查询
#### 2-1、查询必过返回指定字段
```
-- 查询 caseId=5a2f7c28f95e6d63eec0805f，并返回 字段 drugs 和id的值
db.audit_order.find({"caseId" : "5a2f7c28f95e6d63eec0805f"} , {"drugs":1} )

-- 仅返回指定字段
db.audit_order.find({"caseId" : "5a2f7c28f95e6d63eec0805f"} , {"drugs":1,"_id":0} )
```