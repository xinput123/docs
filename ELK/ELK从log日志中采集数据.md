### 1、启动ELK，其中 logstash需要添加配置文件。/config1/file.conf。
```
input {     
	file {
		path => ["F:/log/testLogstash.log"]
		type => "system"
		start_position => "beginning"
	}
}
  
output {
	elasticsearch {
		hosts   => ["localhost:9200"]
	}
	stdout { # 控制台数据，生成环境可以不需要
		codec => rubydebug
	}
}
```

### 2、启动logstash。logstsh的bin目录下
```
logstash -f ..\config1\file.conf
```
