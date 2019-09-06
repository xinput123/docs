#### 1、进入 logstash 的bin目录下，创建config1/redis.conf。
```
input {  
	redis {  
		host        => "192.168.99.100"  
		port        => "6379"  
		data_type   =>"list"  
		key         => "logstash:redis"  
		codec       => "json"  
		type        => "redis-input"  
	}  
}  
  
output {  
	elasticsearch {   
		hosts   => ["localhost:9200"]  
	}  
	stdout {   
		codec => rubydebug   
	}  
} 
```

#### 2、启动 logstash。
```
logstash -f ..\config1\redis.conf
```    

#### 3、在redis中输入数据，从logstash的页面中查看数据，或者可以从 elasticsearch 的head页面或者Kibana页面查看即可。
```
LPUSH logstash:redis "helloworld3"
```    

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-22964ab75f46d4f1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


