## 一、打印mybatis日志
#### 1、如果是springboot项目，只要在application.properties里面加上：
```
logging.level.com.你的包名=trace
```

#### 2、如果是 .yml配置文件
```
logging:
  file: logs/${spring.application.name}
  level:
	包名: trace
```