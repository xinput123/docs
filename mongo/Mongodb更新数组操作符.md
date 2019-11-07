# Mongodb更新数组$sort操作符

## 一、$sort修饰符是在使用$push操作符的时候给数组元素排序
$sort修饰符必须和$each修饰符一起使用，你可以传一个空数组给$each修饰符来使$sort修饰符起作用；

```
{
  $push: {
     <field>: {
       $each: [ <value1>, <value2>, ... ],
       $sort: <sort specification>
     }
  }
}
```

## 二、通过文档中的字段对文档进行排序
一个student集合包含如下文档：

```
{
  "_id": 1,
  "quizzes": [
    { "id" : 1, "score" : 6 },
    { "id" : 2, "score" : 9 }
  ]
}
```

#### 2-1、如下更新添加文档到quizzes数组中，然后通过字段score对数组进行升序排列：
```
db.student.update(
   { _id: 1 },
   {
     $push: {
       quizzes: {
         $each: [ { id: 3, score: 8 }, { id: 4, score: 7 }, { id: 5, score: 6 } ],
         $sort: { score: 1 }
       }
     }
   }
)
```

#### 2-2、更新之后数组元素是按照score字段升序排列的：
```
{
	"_id" : 1,
	"quizzes" : [
		{
			"id" : 1,
			"score" : 6
		},
		{
			"id" : 5,
			"score" : 6
		},
		{
			"id" : 4,
			"score" : 7
		},
		{
			"id" : 3,
			"score" : 8
		},
		{
			"id" : 2,
			"score" : 9
		}
	]
}
```

## 三、数组元素时非文档类型的排序
#### 3-1、一个students集合包含如下文档：
```
db.students.insert({ "_id" : 2, "tests" : [  89,  70,  89,  50 ] })
```

#### 3-2、如下操作添加另外两个元素到scores数组中，然后按照元素排序：
```
db.students.update(
   { _id: 2 },
   { $push: { tests: { $each: [ 40, 60 ], $sort: 1 } } }
)
```

#### 3-3、更新过的文档scores数组是按照升序排列的：
```
{
	"_id" : 2,
	"tests" : [
		40,
		50,
		60,
		70,
		89,
		89
	]
}
```

## 四、更新数组只使用sort
#### 4-1、一个students集合包含如下文档：
```
db.students.insert([{ "_id" : 3, "tests" : [  89,  70,  100,  20 ] }])
```

#### 4-2、更新tests字段并且并且降序排列；匹配{ $sort: -1 }和匹配一个空数组给$each修饰符，就像如下文档：
```
db.students.update(
   { _id: 3 },
   { $push: { tests: { $each: [ ], $sort: -1 } } }
)
```

#### 4-3、更新后的文档字段
```
{
	"_id" : 3,
	"tests" : [
		100,
		89,
		70,
		20
	]
}
```

## 五、$sort 和 $push 其他的一些修饰符使用
#### 5-1、一个 student 集合文档有如下文档
```
db.students.insert([{
   "_id" : 5,
   "quizzes" : [
      { "wk": 1, "score" : 10 },
      { "wk": 2, "score" : 8 },
      { "wk": 3, "score" : 5 },
      { "wk": 4, "score" : 6 }
   ]
}]);
```

#### 5-2、如下的$push操作符使用：
- **$each修饰符** 添加多个元素到文档的集合中；
- **$sort修饰符** 排列所有的文档中的元素按score降序；
- **$slice** 取排序后前三个文档集合；

#### 5-3、操作结果是
```
{
	"_id" : 5,
	"quizzes" : [
		{
			"wk" : 1,
			"score" : 10
		},
		{
			"wk" : 2,
			"score" : 8
		},
		{
			"wk" : 5,
			"score" : 8
		}
	]
}
```