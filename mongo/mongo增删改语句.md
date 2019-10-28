## Mongo Update方法
```
db.collection.update(
   <query>,
   <update>,
   {
     upsert: <boolean>,
     multi: <boolean>,
     writeConcern: <document>
   }
)

db.collection.update({}, {$set: {otherkey: ‘otherval’}}, {multi: 1})
```

##### 参数说明
- **query:** update的查询条件，类似sql update查询内where后面的。

- **update:** update的对象和一些更新的操作符，也可以理解为sql update查询内set后面的。

- **upsert:** 可选，这个参数的意思是，如果不存在update的记录，是否插入objNew, true为插入，默认是false，不插入。

- **multi:** 可选，mongodb默认是false，只更新找到的第一条记录，如果这个参数为true，则更新所有按条件查出来的多条记录。

- **writeConcern:** 可选，抛出异常的级别。
