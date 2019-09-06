## 一、新建和删除索引
#### 1、新建Index
```
curl -X PUT 'localhost:9200/weather'
```

<br/>

#### 2、查看Index
```
// 查看当前节点的所有索引信息
curl -X GET 'http://localhost:9200/_cat/indices?v'
```
- **health：** 健康状态
- **status：** 
- **index：** 
- **uuid：** 
- **pri：** 
- **rep：** 
- **docs.count：** 
- **docs.deleted：** 
- **store.size：** 
- **pri.store.size：** 

<br/>

#### 3、删除Index
```
curl -X DELETE 'localhost:9200/weather'
```

<br/>

## 二、数据操作
#### 2-1、新增记录
- **PUT方式** 需要指定Id  /index/type/id。Id任意字符串
- **POST方式** 不指定Id，_id字段是一个随机字符串

```
// PUT 方式
curl -X PUT 'localhost:9200/accounts/person/1' -d '
{
  "user": "张三",
  "title": "工程师",
  "desc": "数据库管理"
}' 

// POST方式
curl -X POST 'localhost:9200/accounts/person' -d '
{
  "user": "王五",
  "title": "工程师",
  "desc": "系统管理"
}'
```

<br/>

#### 2-2、查看记录
```
curl 'localhost:9200/accounts/person/1?pretty=true'
```
> 请求的数据
- **/Index/Type/Id** 发出GET请求
- **pretty=true** 表示以易读的格式返回

> 返回的数据
- **found** true表示查询成功，false表示查不到数据
- **source** 字段返回原始记录
- **_index** 索引，相当于数据库表名

<br/>

#### 2-3、删除记录
```
curl -X DELETE 'localhost:9200/accounts/person/1'
```

<br/>

#### 2-4、更新记录
- 更新记录就是使用 PUT 请求，重新发送一次数据。

```
curl -X PUT 'localhost:9200/accounts/person/1' -d '
{
    "user" : "张三",
    "title" : "工程师",
    "desc" : "数据库管理，软件开发"
}' 
```
> 返回数据,可以看到Id没有变
- version 版本从1变成2
- result 操作类型 从create变成update
- create 变成false，因为是变更记录，不是新建记录


<br/>

## 三、数据查询
#### 3-1、返回所有记录
```
http://localhost:9200/accounts/person/_search
```
> 返回结果
- **took** 操作耗时，单位是毫秒ms
- **time_out** 是否超时
- **hits** 命中的记录
- **hits.total** 返回记录数
- **hits.max_scores** 最高的匹配程度
- **hits.htis** 返回的记录组成的数组
- **hits.htis._score** 匹配的程序，默认是按照这个字段降序排列

<br/>

#### 3-2、全文搜索
- **Match查询**

```
curl 'localhost:9200/accounts/person/_search'  -d '
{
  "query" : { "match" : { "desc" : "数据库" }},
  "from" : 1,
  "size" : 1
}'
```
- query 指定的匹配条件是 desc 字段里面包含"软件"这个词
- from 指定位移，默认从0开始
- size Elastic默认一次返回10条结果，可以通过size设置返回结果个数

<br/>

#### 3-3、逻辑运算
```
// or 有多个搜索关键字，默认是or关系，搜索"软件" 或者 "开发"
curl 'localhost:9200/accounts/person/_search'  -d '
{
  "query" : { "match" : { "desc" : "软件 开发" }}
}'

// and搜索，必须使用布尔查询
curl 'localhost:9200/accounts/person/_search'  -d '
{
  "query": {
    "bool": {
      "must": [
        { "match": { "desc": "软件" } },
        { "match": { "desc": "系统" } }
      ]
    }
  }
}'
```

<br/>

## 四、聚合
