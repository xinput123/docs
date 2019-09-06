ELK(Elasticsearch、Logstash、Kibana )是一种能够从任意数据源抽取数据，并实时对数据进行搜索、分析和可视化展现的数据分析框架。需要jdk1.8或以上的支持。

我的ELK目录位置：F:\soft\ELK
![](http://upload-images.jianshu.io/upload_images/4046640-0da0ecc4abac0ada.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)Paste_Image.png

- Elasticsearch是个开源分布式搜索引擎，它的特点有：分布式，零配置，自动发现，索引自动分片，索引副本机制，restful风格接口，多数据源，自动搜索负载等。要负责数据存储与搜索。

- Logstash是一个完全开源的工具，他可以对你的日志进行收集、过滤，并将其存储供以后使用（如，搜索）。主要负责收集日志信息以及对日志信息的切片索引等处理。

- Kibana 是一个web界面，负责将信息进行图形展示。

## 一、Elasticsearch 配置启动。
#### 1、修改配置文件：F:\soft\ELK\elasticsearch-5.4.2\config\elasticsearch.yml。
```
path.data: F://log/elk/data          ##日志存储目录

path.logs: F://log/elk/logs          ##elasticsearch启动日志路径

network.host: localhost       ##主机IP，这里是本地

http.port: 9200               ##默认端口

node.name: "node-2"          ##多节点时nodenama不能相同

node.master: true        ## 主节点

node.data: true           #是否存储数据

bootstrap.memory_lock: true   ##内存锁设定，一定要打开

# 手动发现节点,我这里有两个节点加入到elk集群
# discovery.zen.ping.unicast.hosts: [localhost]

# 增加如下字段
http.cors.enabled: true
http.cors.allow-origin: "*"
```

#### 2、堆大小检测 F:\soft\ELK\elasticsearch-5.4.2\config\jvm.options。
```
-Xms2g
-Xmx2g
```

最大堆内存和最小堆内存两者值设定为一至，同时尽可能大，同时不要超过32G，最大堆内存和最小堆内存如果不一致，在启动中的时候会进行内存大小自动调整，可能会出现中断的情况，为了避免此情况的产生，所以heap_check中要求最大内存最小内存相当，本例中设置为2G。

#### 3、文件打开数，linux中在/etc/security/limits.conf增加elasticsearch最大文件打开数为65536。windows下没有研究。
```
elasticsearch soft nofile 65536
elasticsearch hard nofile 65536
```

#### 4、启动Elasticsearch，浏览器访问http://localhost:9200，可以查看到对应的节点信息。

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-05166d9e707865d8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 二、配置、启动 logstash
#### 1、在 logstash的主目录下创建 config1\log_test.conf 。
```
input {
  log4j {
	mode => "server"
	host => "localhost"
	port => 4560    // 指定从 localhost:4560断口处 获取 日志
  }
}

filter {
  #Only matched data are send to output.
}

output {
	elasticsearch {
	action => "index"          #The operation on ES
	hosts  => "localhost:9200"   // 输出到ElasticSearch  
	index  => "applog"         #The index to write data to.
  }
}
```

#### 2、修改后保存，启动
```
logstash -f ..\config1\log_test.conf
```    

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-0eecd3f5883e9b34.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

访问localhost:9600，说明启动成功。


## 三、配置、启动kibana
#### 1、修改配置文件，F:\soft\ELK\kibana-5.4.2-windows-x86\config\kibana.yml。
```
# elasticsearch.url的值必须设定，为elasticsearch的主机ip
server.port: 5601
server.host: "0.0.0.0"
elasticsearch.url: "http://localhost:9200"
```

#### 2、启动，双击kibana.bat，访问 localhost:5601。

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-54dfd7b7ea87cf54.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 3、创建 index ，红色框中的值是 logstash-5.4.2 中 log_test.conf配置文件中指定的 index。创建后 点击discovery。创建index 在项目启动后，产生日志了再 创建index。否则，kibana会提示找不到对应的索引。

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-5c9af69cd414cd5e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-00d17176b62f7be5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 四、安装 head 插件。
#### 1、下载 node.js,并安装，并把NODE_HOME设置到环境变量里(安装包也可以自动加入PATH环境变量)。
```
node -v
```

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-1eac32f17f2ebd04.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

[node.js下载地址](https://nodejs.org/en/)

#### 2、安装grunt。
```
npm install -g grunt-cli
grunt -version   -- 安装后 ，查看 grunt版本。
```

-g代表全局安装。安装路径为C:\Users\yourname\AppData\Roaming\npm，并且自动加入PATH变量。安装完成后检查一下。

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-43801c5c751b39ea.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-3084c41dc2cdae1c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

grunt是一个很方便的构建工具，可以进行打包压缩、测试、执行等等的工作，5.0里的head插件就是通过grunt启动的。因此需要安装grunt。

#### 3、下载 head 插件的源码。
```
git clone git://github.com/mobz/elasticsearch-head.git
```    

#### 4、修改head源码。因为 head版本还是2.6，直接执行有很多限制，比如无法跨机器访问。因此需要用户修改两个地方。
##### 4-1、head/Gruntfile.js，增加hostname属性，设置为*。
```
connect: {
	server: {
		options: {
			port: 9100,
			hostname: '*',
			base: '.',
			keepalive: true
		}
	}
	}
```

##### 4-2、head/_site/app.js。修改head的连接地址。
```
this.base_uri = this.config.base_uri || this.prefs.get("app-base_uri") || "http://localhost:9200";  
    
把localhost修改成你es的服务器地址，如：
this.base_uri = this.config.base_uri || this.prefs.get("app-base_uri") || "http://10.10.10.10:9200";
```

### 5、运行head。
##### 5-1、修改elasticsearch的参数。config/elasticsearch.yml
```
# 换个集群的名字，免得跟别人的集群混在一起
cluster.name: es-5.0-test

# 换个节点名字
node.name: node-101

# 修改一下ES的监听地址，这样别的机器也可以访问
network.host: 0.0.0.0

# 默认的就好
http.port: 9200

# 增加新的参数，这样head插件可以访问es
http.cors.enabled: true
http.cors.allow-origin: "*"
```

##### 5-2、然后在head源码目录中，执行npm install 下载的包：
```
npm install
```

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-139d4e2d7697eadf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

初次运行安装可能会报警告或错误。可以重新运行一次npm install。
最后，在head源代码目录下启动nodejs，运行 grunt server。

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-0a1ae2fb9556feca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 6、访问 http://localhost:9100。

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/4046640-1ad7cd331d785000.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)