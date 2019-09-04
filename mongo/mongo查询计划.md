## 一、explain 查看执行计划。
3.0+的explain有三种模式，分别是：queryPlanner、executionStats、allPlansExecution。现实开发中，常用的是executionStats模式，主要分析这种模式。

```
// 插入200W条数据
for(var i=0;i<2000000;i++){
    db.person.insert({"name":"ryan"+i,"age":i})
}

// 创建索引
db.person.createIndex({"age":1})

// 查看执行计划
db.getCollection('person')
  .find({"age":{"$lte":2000}})
  .explain("executionStats")
```

**返回值如下：**

```
{
"queryPlanner" : {
	"plannerVersion" : 1,
	"namespace" : "xx.person",
	"indexFilterSet" : false,
	"parsedQuery" : {
		"age" : {
			"$lte" : 2000.0
		}
	},
	"winningPlan" : {
		"stage" : "FETCH",
		"inputStage" : {
			"stage" : "IXSCAN",
			"keyPattern" : {
				"age" : 1.0
			},
			"indexName" : "age_1",
			"isMultiKey" : false,
			"multiKeyPaths" : {
				"age" : []
			},
			"isUnique" : false,
			"isSparse" : false,
			"isPartial" : false,
			"indexVersion" : 2,
			"direction" : "forward",
			"indexBounds" : {
				"age" : [ 
					"[-inf.0, 2000.0]"
				]
			}
		}
	},
	"rejectedPlans" : []
},
"executionStats" : {
	"executionSuccess" : true,
	"nReturned" : 2001,
	"executionTimeMillis" : 2,
	"totalKeysExamined" : 2001,
	"totalDocsExamined" : 2001,
	"executionStages" : {
		"stage" : "FETCH",
		"nReturned" : 2001,
		"executionTimeMillisEstimate" : 0,
		"works" : 2002,
		"advanced" : 2001,
		"needTime" : 0,
		"needYield" : 0,
		"saveState" : 15,
		"restoreState" : 15,
		"isEOF" : 1,
		"invalidates" : 0,
		"docsExamined" : 2001,
		"alreadyHasObj" : 0,
		"inputStage" : {
			"stage" : "IXSCAN",
			"nReturned" : 2001,
			"executionTimeMillisEstimate" : 0,
			"works" : 2002,
			"advanced" : 2001,
			"needTime" : 0,
			"needYield" : 0,
			"saveState" : 15,
			"restoreState" : 15,
			"isEOF" : 1,
			"invalidates" : 0,
			"keyPattern" : {
				"age" : 1.0
			},
			"indexName" : "age_1",
			"isMultiKey" : false,
			"multiKeyPaths" : {
				"age" : []
			},
			"isUnique" : false,
			"isSparse" : false,
			"isPartial" : false,
			"indexVersion" : 2,
			"direction" : "forward",
			"indexBounds" : {
				"age" : [ 
					"[-inf.0, 2000.0]"
				]
			},
			"keysExamined" : 2001,
			"seeks" : 1,
			"dupsTested" : 0,
			"dupsDropped" : 0,
			"seenInvalidated" : 0
		}
	}
},
"serverInfo" : {
	"host" : "bd7c326d9d51",
	"port" : 27017,
	"version" : "3.6.2",
	"gitVersion" : "489d177dbd0f0420a8ca04d39fd78d0a2c539420"
},
"ok" : 1.0
}
```

<br/>

### 1、对queryPlanner分析
- **namespace** : 该值返回的是该query所查询的表
- **indexFilterSet** : 针对该query是否有indexfilter
- **winningPlan** : 查询优化器针对该query所返回的最优执行计划的详细内容。
- **winningPlan.stage** : 最优执行计划的stage，这里返回是FETCH，可以理解为通过返回的index位置去检索具体的文档.
- **winningPlan.inputStage** : 用来描述子stage，并且为其父stage提供文档和索引关键字。
- **winningPlan.stage.stage，此处是IXSCAN，表示进行的是index scanning。
- **winningPlan.stage.keyPattern** :所扫描的index内容，此处是 "age" : 1.0
- **winningPlan.indexName** ：winning plan所选用的index。
- **winningPlan.isMultiKey**：是否是Multikey，此处返回是false，如果索引建立在array上，此处将是true。
- **winningPlan.direction** ：此query的查询顺序，此处是forward，如果用了.sort({modify_time:-1})将显示backward。
- **winningPlan.indexBounds:winningplan** : 所扫描的索引范围,如果没有制定范围就是[MaxKey, MinKey]，这主要是直接定位到mongodb的chunck中去查找数据，加快数据读取。
- **rejectedPlans** ：其他执行计划（非最优而被查询优化器reject的）的详细返回，其中具体信息与winningPlan的返回中意义相同.

### 2、对executionStats返回逐层分析
##### 2-1、第一层，executionTimeMillis
最为直观explain返回值是executionTimeMillis值，指的是我们这条语句的执行时间，这个值当然是希望越少越好。其中有3个executionTimeMillis，分别是：
- **executionTimeMillis ：** 该query的整体查询时间。
- **executionStages.executionTimeMillisEstimate ：** 该查询根据index去检索document获得2001条数据的时间。
- **executionStages.inputStage.executionTimeMillisEstimate ：** 该查询扫描2001行index所用时间。

<br/>

#### 2-2、第二层，index与document扫描数与查询返回条目数
这个主要讨论3个返回项，nReturned、totalKeysExamined、totalDocsExamined，分别代表该条查询返回的条目、索引扫描条目、文档扫描条目。

这些都是直观地影响到executionTimeMillis，我们需要扫描的越少速度越快。

对于一个查询，我们最理想的状态是：nReturned=totalKeysExamined=totalDocsExamined

<br/>

#### 2-3、第三层，stage状态分析
那么又是什么影响到了totalKeysExamined和totalDocsExamined？是stage的类型。类型列举如下：

- **COLLSCAN** ：全表扫描
- **IXSCAN**：索引扫描
- **FETCH** ：根据索引去检索指定document
- **SHARD_MERGE** ：将各个分片返回数据进行merge
- **SORT** ：表明在内存中进行了排序
- **LIMIT** ：使用limit限制返回数
- **SKIP** ：使用skip进行跳过
- **IDHACK** ：针对_id进行查询
- **SHARDING_FILTER** ：通过mongos对分片数据进行查询
- **COUNT** ：利用db.coll.explain().count()之类进行count运算
- **COUNTSCAN**：count不使用Index进行count时的stage返回
- **COUNT_SCAN** ：count使用了Index进行count时的stage返回
- **SUBPLA** ：未使用到索引的$or查询的stage返回
- **TEXT** ：使用全文索引进行查询时候的stage返回
- **PROJECTION** ：限定返回字段时候stage的返回
- **对于普通查询，我希望看到stage的组合(查询的时候尽可能用上索引) ：**
- **Fetch+IDHACK**
- **Fetch+ixscan**
- **Limit+（Fetch+ixscan）**
- **PROJECTION+ixscan**
- **SHARDING_FITER+ixscan**
- **COUNT_SCAN**

**不希望看到包含如下的stage：**

- **COLLSCAN(全表扫描)**
- **SORT(使用sort但是无index)**
- **不合理的SKIP**
- **SUBPLA(未用到index的$or)**
- **COUNTSCAN(不使用index进行count)**